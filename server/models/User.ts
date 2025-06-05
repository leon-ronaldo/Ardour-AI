class User {
  userId: string;
  username: string;
  firstName: string;
  lastName: string;
  email: string;
  contacts: string[];
  createdOn: string;

  constructor(
    userId: string,
    username: string,
    firstName: string,
    lastName: string,
    email: string,
    contacts: string[] = [],
    createdOn: string = new Date().toISOString()
  ) {
    this.userId = userId;
    this.username = username;
    this.firstName = firstName;
    this.lastName = lastName;
    this.email = email;
    this.contacts = contacts;
    this.createdOn = createdOn;
  }

  isAuthorized(): boolean {
    return true;
  }
}

export default User;
