function prompt {
  function gitPrompt {
    if (git rev-parse --is-inside-work-tree 2> $null) {
      $branch = '(unknown)'
      $stat = ''

      if (git rev-parse --is-inside-git-dir 2> $null -eq "false") {
        # Check for uncommitted changes
        if (git diff --ignore-submodules --cached) { $stat += '+' }

        # Check for unstaged changes
        if (git diff-files --ignore-submodules --) { $stat += '!' }

        # Check for untracked files
        if (git ls-files --others --exclude-standard) { $stat += '?' }

        # Check for stashed files
        if (git rev-parse --verify refs/stash 2> $null) { $stat += '$' }
      }

      $branch = git symbolic-ref --quiet --short HEAD 2> $null
      if (!$?) { $branch = git rev-parse --short HEAD 2> $null }
      if ($stat) { $stat = "[$stat]" }
      return " $([char]0x2387) $branch$stat"
    }

    return ""
  }

  $exitStatus = $?
  $esc = [char]27
  $loc = $executionContext.SessionState.Path.CurrentLocation;
  $prompt = ""
  if ($loc.Provider.Name -eq "FileSystem") {
    $prompt += "$([char]27)]9;9;`"$($loc.ProviderPath)`"$([char]27)\"
  }
  $prompt += "$esc[35m@${env:COMPUTERNAME}: "
  $prompt += "$esc[33m$(Get-Location)"
  $prompt += "$esc[36m$(gitPrompt)"
  $prompt += "`r`n"
  $prompt += if ($exitStatus) { "$esc[0m" } else { "$esc[31m" }
  $prompt += "> $esc[0m"
  return $prompt
}

Set-PSReadLineOption -Colors @{
  Default   = "Yellow"
  Member    = "Yellow"
  Number    = "Yellow"
  Parameter = "Yellow"
}

$Profile_PrevVenvPath = ""
# These tools might exists later.
$Profile_HasPoetry = $false
$Profile_VenvToolsChecked = $false

function venv {
  $searchPath = Get-Location

  if (!$Profile_VenvToolsChecked) {
    $script:Profile_VenvToolsChecked = $true
    $script:Profile_HasPoetry = [boolean](
      Get-Command poetry -errorAction SilentlyContinue
    )
  }

  function activate {
    $activatePath = "$searchPath/.venv/Scripts/activate"

    if (
      ("$activatePath" -eq "$Profile_PrevVenvPath") -and
      (Test-Path env:VIRTUAL_ENV)
    ) {
      return
    }

    if (Test-Path $activatePath) {
      if (Get-Command deactivate -errorAction SilentlyContinue) {
        deactivate 2>$null
      }

      & "$activatePath"

      if (Test-Path env:VIRTUAL_ENV) {
        $script:Profile_PrevVenvPath = "$activatePath"
      }

      return
    }


    if ($Profile_HasPoetry) {
      $pyprojectPath = "$searchPath/pyproject.toml"

      if (
        ("$pyprojectPath" -eq "$Profile_PrevVenvPath") -and
        (Test-Path env:VIRTUAL_ENV)
      ) {
        return
      }

      if (Test-Path $pyprojectPath) {
        if ((Select-String tool.poetry "$pyprojectPath") -eq $null) {
          return
        }

        if (Get-Command deactivate -errorAction SilentlyContinue) {
          deactivate 2>$null
        }

        $envPath = poetry env info --path

        if ($envPath) {
          & "$envPath/Scripts/activate.ps1"
        }
        else {
          poetry shell
        }

        if (Test-Path env:VIRTUAL_ENV) {
          $script:Profile_PrevVenvPath = "$pyprojectPath"
        }

        return
      }
    }

    if ($searchPath) {
      $searchPath = (Get-Item "$searchPath").Parent.FullName
      activate
    }
  }

  activate
}

Set-Alias -Name g -Value git
Set-Alias -Name vi -Value vim
