#Binary Network Token Format

The Binary Token is used in the binary network protocol to keep session information, allowing a reliable and cross node session, in the token are kept all the information that are needed for identify the database and user authenticated, plus a verification signature.

##Token content detail

* *type* the format of token to allow extensibility.
* *algorithm* the algorithm used to generate the validation signature.
* *key id* the identifier of the key used for sign the token.
* *database name* the current database name.
* *database type* the type of the authenticated database (plocal or memory).
* *user id* the current authenticate user id.
* *protocol version* the protocol version of the authenticated client.
* *serializer* the serializer used by the authenticated client.
* *driver name* the name of the client.
* *driver version* the version of the client.
* *is server user* a flag to manage server user authentication.
* *server user name* if is a server user keep the username because doesn't exist an user id.
* *expiry* the type when the token is considerated expired. 

## token serialization
