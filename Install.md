### For users
#### OrientDB v1.6 or higher

Copy the **studio.jar** file to the directory "plugins" on the OrientDB Server.

#### OrientDB v1.4 - v1.5

Unpack the **studio.jar** file to the directory "www/studio" on the OrientDB Server. If you want to keep the previous version of studio, then rename the existing "www/studio" directory ex. "www/studioprev".

### For Developers

#### Quick Start

0. Install [Node.js](http://nodejs.org/) and NPM 

1. Clone the repository:

    ```bash
    $ git clone https://github.com/orientechnologies/orientdb-studio.git
    ```

2. Install global dependencies `yo`, `bower` and `compass` (remove "sudo" if your account already has the permissions to install software):

    ```bash
    $ sudo npm install -g yo bower compass
    ```

3. Install local dependencies:

    ```bash
    $ npm install
    $ bower install
    ```

4. Start the OrientDB server.


5. Start the server grunt and your browser will be opened at `http://localhost:9000`:

    ```bash
	$ grunt server
    ```

   If you're using Studio bundled in OrientDB, connect with your browser to: `http://localhost:2480/studio/index.html`

6. If you want to create a distribution to install under the OrientDB Server ('plugins' directory), just type:

    ```bash
	$ grunt build
    ```