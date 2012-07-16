window.angelo = (path) ->
  window.templates ||= {}
  template = window.templates[path]
  return template if template

  $.ajax
    url: "/templates/#{path}",
    method: 'GET',
    async: false,
    success: (data) ->
      template = data
  window.templates[path] = template
  template
