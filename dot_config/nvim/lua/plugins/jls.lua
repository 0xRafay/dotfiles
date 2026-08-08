-- must install `shasum` package
return {
  'idelice/nvim-jls',
  opts = {
    jls_dir = nil, -- defaults to managed install (~/.local/share/nvim/jls); set to override
    settings = {}, -- passed through to the JLS LSP settings payload
    root_markers = {
      'pom.xml',
      'build.gradle',
      'build.gradle.kts',
      'settings.gradle',
      'settings.gradle.kts',
      'WORKSPACE',
      'WORKSPACE.bazel',
      '.java-version',
      '.git',
    },
    inlay_hints = {
      enabled = true, -- show parameter name hints at call sites
    },
    jvm_args = nil, -- override JVM args (default: -Xmx2g -Xms512m ...)
    cmd_env = {}, -- extra environment variables passed to the JLS process
    auto_restart = false, -- automatically restart JLS if it crashes (up to 3 attempts with backoff)
  },
}
