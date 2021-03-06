Template.home_tasks.helpers({
    tasks: function () {
        if (Session.get("hideCompleted")) {
            return Tasks.find({checked: {$ne: true}}, {sort: {createdAt: -1}});
        } else {
            return Tasks.find({}, {sort: {createdAt: -1}});
        }
    },
    hideCompleted: function () {
        return Session.get("hideCompleted");
    },
    incompleteCount: function () {
        return Tasks.find({checked: {$ne: true}}).count();
    }
});

Template.home_tasks.events({
    "submit .new-task": function (event) {
        // This function is called when the new task form is submitted
        var text = event.target.text.value;

        Meteor.call("addTask", text);

        // Clear form
        event.target.text.value = "";

        // Prevent default form submit
        return false;
    },
    "change .hide-completed input": function (event) {
        Session.set("hideCompleted", event.target.checked);
    }
});