BEGIN TRANSACTION;

INSERT INTO users (first_name,last_name,username,password_hash,role,email_address) VALUES ('a','b','user1','user1','ROLE_USER','email@email.com');
INSERT INTO users (first_name,last_name,username,password_hash,role,email_address) VALUES ('a','b','user2','user2','ROLE_USER','email@email.com');
INSERT INTO users (first_name,last_name,username,password_hash,role,email_address) VALUES ('a','b','user3','user3','ROLE_USER','email@email.com');

INSERT INTO pets (name, species, sex, birth_date, is_fixed, has_vaccinations, size, user_id) VALUES ('pet1', 'dog', 'male', '2022-01-20', true, true, 2, 1);
INSERT INTO pets (name, species, sex, birth_date, is_fixed, has_vaccinations, size, user_id) VALUES ('pet2', 'dog', 'male', '2022-01-20', true, true, 2, 1);
INSERT INTO pets (name, species, sex, birth_date, is_fixed, has_vaccinations, size, user_id) VALUES ('pet3', 'dog', 'male', '2022-01-20', true, true, 2, 1);



INSERT INTO personality (type) VALUES ('timid');
INSERT INTO personality (type) VALUES ('tires quickly');
INSERT INTO personality (type) VALUES ('independent');


INSERT INTO pet_personality (pet_id, personality_id) VALUES (1, 1);
INSERT INTO pet_personality (pet_id, personality_id) VALUES (1, 2);
INSERT INTO pet_personality (pet_id, personality_id) VALUES (1, 3);

INSERT INTO pet_personality (pet_id, personality_id) VALUES (2, 1);
INSERT INTO pet_personality (pet_id, personality_id) VALUES (2, 2);
INSERT INTO pet_personality (pet_id, personality_id) VALUES (2, 3);

INSERT INTO pet_personality (pet_id, personality_id) VALUES (3, 1);
INSERT INTO pet_personality (pet_id, personality_id) VALUES (3, 2);
INSERT INTO pet_personality (pet_id, personality_id) VALUES (3, 3);

INSERT INTO playdate (host_id, visitor_id, zip_code, date_and_time, details, rating, status, playdate_photo)
VALUES (1, 2, 15212, '2022-08-20T12:30:00', 'Join me at my house for snacks and fetch!', 3, 'Posted', 'photoURL');

INSERT INTO playdate (host_id, visitor_id, zip_code, date_and_time, details, rating, status, playdate_photo)
VALUES (2, 3, 15212, '2022-10-02T12:00:00', 'Super fun playdate at the park!', 5, 'Accepted', 'photoURL');

INSERT INTO playdate (host_id, visitor_id, zip_code, date_and_time, details, rating, status, playdate_photo)
VALUES (1, 2, 15202, '2022-09-15T12:45:00', 'Go on a walk with us!', 2, 'Declined', 'photoURL');

INSERT INTO pet_playdate (playdate_id, pet_id) VALUES (1, 1);
INSERT INTO pet_playdate (playdate_id, pet_id) VALUES (1, 2);
INSERT INTO pet_playdate (playdate_id, pet_id) VALUES (2, 1);
INSERT INTO pet_playdate (playdate_id, pet_id) VALUES (2, 2);
INSERT INTO pet_playdate (playdate_id, pet_id) VALUES (3, 1);
INSERT INTO pet_playdate (playdate_id, pet_id) VALUES (3, 2);


COMMIT TRANSACTION;
