Router.route('/', {
    name: 'home.tasks',
    layoutTemplate: 'layout',
    template: 'home_tasks',
    subscriptions: function() {
        this.subscribe("tasks");
    },
    action: function () {
        this.render();
    }
});

Router.route('/task/:_id', {
    name: 'single.task',
    layoutTemplate: 'layout',
    template: 'single_task',
    waitOn: function() {
        return [Meteor.subscribe('tasks')];
    },
    data: function (){
        return Tasks.findOne({id: this.params._id});
    },
    action: function(){
        this.render();
    }
});

Router.route('/files', function () {
    this.response.end('hi from the Meteor server\n');
}, {where: 'server'});
