Template.task.events({
    "click .toggle-checked": function () {
        // Set the checked property to the opposite of its current value
        Meteor.call("setChecked", this._id, ! this.checked);
    },
    "click .delete": function () {
        Meteor.call("deleteTask", this._id);
    },
    "click .toggle-private": function () {
        Meteor.call("setPrivate", this._id, ! this.private);
    },
    'click [data-action="go-single-task"]': function(event) {
        event.preventDefault();
        Router.go('single.task', {_id: this._id});
    }
});

Template.task.helpers({
    isOwner: function () {
        return this.owner === Meteor.userId();
    }
});