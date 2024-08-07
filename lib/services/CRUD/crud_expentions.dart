import 'dart:developer'as devtools show log;


class DbAlreadyOpenedException implements Exception {
  DbAlreadyOpenedException() {
    devtools.log("The Database is already opened");
  }
}

class UnableTOGetDocumentDirectoryException implements Exception {
  UnableTOGetDocumentDirectoryException() {
    devtools.log("Unable to open document directory");
  }
}

class NoOpenedDbException implements Exception {
  NoOpenedDbException() {
    devtools.log("No Database is currrntly opened, open one first");
  }
}

class CouldNotDeleteUser implements Exception {
  CouldNotDeleteUser() {
    devtools.log("User could not be deleted");
  }
}

class InsertionError implements Exception {
  InsertionError() {
    devtools.log("Failed to insert a new user with this email");
  }
}

class UserAlreadtPresent implements Exception {
  UserAlreadtPresent() {
    devtools.log("Failed to insert a new user with this email, a user with this email is already present");
  }
}

class NoSuchUserINDbException implements Exception {
  NoSuchUserINDbException() {
    devtools.log("No user in the Database has this email");
  }
}

class NoteAlreadyExists implements Exception {
  NoteAlreadyExists() {
    devtools.log("This note already exists");
  }
}

class CouldNotMakeNoteException implements Exception {
  CouldNotMakeNoteException() {
    devtools.log("Failed to create Note");
  }
}

class CouldNotDeleteNoteException implements Exception {
  CouldNotDeleteNoteException() {
    devtools.log("No such not to be deleted");
  }
}

class NoNotesToDeleteException implements Exception {
  NoNotesToDeleteException() {
    devtools.log("No notes to delete in the entire db");
  }
}

class CouldNotFindNoteException implements Exception {
  CouldNotFindNoteException() {
    devtools.log("No notes to macthes that id");
  }
}

class NotASingleNoteInDb implements Exception {
  NotASingleNoteInDb() {
    devtools.log("No notes in the db to print any of them");
  }
}

class CouldNotFindNoteToUpdateException implements Exception {
  CouldNotFindNoteToUpdateException() {
    devtools.log("did find that not to update it");
  }
}
