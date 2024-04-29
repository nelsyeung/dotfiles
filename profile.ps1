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
  $prompt = "$esc[35m@${env:COMPUTERNAME}: "
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

Set-Alias -Name g -Value git
Set-Alias -Name vi -Value vim
