window.ENV = 'test'
window.CURRENT_USER ||= null
App.router = new App.MainRouter
App.topics = new App.Topics([{id: 1, title: 'Hello'}])
App.codemarks = new App.Codemarks()
