CREATE TABLE dogs (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  owner_id INTEGER,

  FOREIGN KEY(owner_id) REFERENCES human(id)
);

CREATE TABLE humans (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  house_id INTEGER,

  FOREIGN KEY(house_id) REFERENCES human(id)
);

CREATE TABLE houses (
  id INTEGER PRIMARY KEY,
  address VARCHAR(255) NOT NULL
);

INSERT INTO
  houses (id, address)
VALUES
  (1, "593 7th Street"), (2, "4501 North Charles Street");

INSERT INTO
  humans (id, fname, lname, house_id)
VALUES
  (1, "Tim", "Callahan", 1),
  (2, "Mantis", "Toboggan", 1),
  (3, "Tommy", "Lightbulbs", 2),
  (4, "Dogless", "Human", NULL);

INSERT INTO
  dogs (id, name, owner_id)
VALUES
  (1, "Albert", 1),
  (2, "Fido", 2),
  (3, "Saint", 3),
  (4, "Bartleby", 3),
  (5, "Stray Dog", NULL);
