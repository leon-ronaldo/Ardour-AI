import User from "../models/User";

const USERS = new Map<string, User>();

USERS.set("u001", new User(
  "u001", "john_doe", "John", "Doe", "john.doe@example.com",
  ["u002", "u003", "u004"]
));

USERS.set("u002", new User(
  "u002", "jane_smith", "Jane", "Smith", "jane.smith@example.com",
  ["u001", "u003"]
));

USERS.set("u003", new User(
  "u003", "robert_lee", "Robert", "Lee", "robert.lee@example.com",
  ["u001", "u002", "u005"]
));

USERS.set("u004", new User(
  "u004", "alice_wang", "Alice", "Wang", "alice.wang@example.com",
  ["u001"]
));

USERS.set("u005", new User(
  "u005", "michael_kim", "Michael", "Kim", "michael.kim@example.com",
  ["u003", "u006"]
));

USERS.set("u006", new User(
  "u006", "lisa_chen", "Lisa", "Chen", "lisa.chen@example.com",
  ["u005", "u002"]
));

export default USERS;
