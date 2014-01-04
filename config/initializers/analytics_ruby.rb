Analytics = AnalyticsRuby          # Alias for convenience
Analytics.init({
    secret: 'vshafc8f00',          # The write key for gmassanek/codemarks
    on_error: Proc.new { |status, msg| print msg }  # Optional error handler
})
