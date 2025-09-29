$ErrorActionPreference = 'Stop'

winget install jdx.mise

mise settings experimental=true
mise settings add idiomatic_version_file_enable_tools "[]"
