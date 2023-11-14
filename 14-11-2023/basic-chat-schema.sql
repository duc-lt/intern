CREATE TYPE user_current_status AS ENUM('active', 'inactive');
CREATE TYPE friend_status AS ENUM('requested', 'accepted', 'blocked');
CREATE TYPE message_type AS ENUM('text', 'media');
CREATE TYPE media_message_type AS ENUM('image', 'audio', 'video');

CREATE TABLE users (
    id INT GENERATED ALWAYS AS IDENTITY,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    email VARCHAR(30) NOT NULL,
    passwd VARCHAR(100) NOT NULL,
    current_status user_current_status,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY(id)
);

CREATE TABLE friends (
    user_id INT,
    friend_id INT,
    status friend_status,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_friends_user_users FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_friends_friend_users FOREIGN KEY(friend_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE conversations (
    id INT GENERATED ALWAYS AS IDENTITY,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY(id)
);

CREATE TABLE conversations_users (
    member_id INT GENERATED ALWAYS AS IDENTITY,
    conversation_id INT,
    user_id INT,
    nickname VARCHAR(30),
    
    CONSTRAINT fk_convs_users_convs FOREIGN KEY(conversation_id) REFERENCES conversations(id) ON DELETE CASCADE,
    CONSTRAINT fk_convs_users_users FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE,
    PRIMARY KEY(member_id)
);

CREATE TABLE messages (
    id INT GENERATED ALWAYS AS IDENTITY,
    sender_id INT,
    message_type message_type,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_messages_convs_users FOREIGN KEY(sender_id) REFERENCES conversations_users(member_id) ON DELETE CASCADE,
    PRIMARY KEY(id)
);

CREATE TABLE text_messages (
    message_id INT,
    message_content TEXT,
    
    CONSTRAINT fk_text_messages_messages FOREIGN KEY(message_id) REFERENCES messages(id) ON DELETE CASCADE
);

CREATE TABLE media_messages (
    message_id INT,
    media_type media_message_type,
    url VARCHAR(200),
    
    CONSTRAINT fk_media_messages_messages FOREIGN KEY(message_id) REFERENCES messages(id) ON DELETE CASCADE
);

