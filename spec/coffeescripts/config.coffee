window.ENV = 'jasmine'
window.CURRENT_USER ||= null
App.router = new App.MainRouter
App.topics = new App.Topics([{id: 1, title: 'Hello', slug: 'hello'}, {id: 2, title: 'Github', slug: 'github'}])
App.codemarks = new App.Codemarks()
