class TaskModel {
  var id;
  var title;
  var done = false;

  TaskModel(String id, String title, { done: false }) {
    this.title = title;
    this.id = id;
    this.done = done;
  }
}