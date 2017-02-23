---
search:
   keywords: ['Python', 'PyOrient', 'Python API']
---

# PyOrient

OrientDB supports all JVM languages for server-side scripting.  Using the PyOrient module, you can develop database applications for OrientDB using the Python language.

It works with version 1.7 and later of OrientDB.



## Installation

In order to use PyOrient, you need to install it on your system.  There are two methods available to you in doing this: you can install it from the Python Package Index (PyPI) or you can download the latest source code from GitHub and build it on your local system.

You'll need to have Python in desired version, (2 or 3), as well as the Python package management tool pip installed on your system as a prerequisite.

### Installing from PyPI

When you call pip and provided it with the specific package name, it connects to the Python Package Index and downloads the current source package for PyOrient.  It then runs the setup script to install the package on  your system, either at a global or user level.  Installing it at a system-level requires that you run pip as root or with sudo and installs the package as a system-level Python library, (for instance `/usr/lib/python3.4/site-packages/pyorient`). Installing it at a local-level does not require root privileges and installs it as a user-level Python library, (for instance `~/.local/lib/python3.4/site-packages/pyorient`).

- To install PyOrient locally, run the following command:

  <pre>
  $ <code class="lang-sh userinput">pip install pyorient --user</code>
  </pre>

- To install PyOrient globally, instead run this command:

  <pre>
  $ <code class="lang-sh userinput">sudo pip install pyorient</code>
  </pre>

When pip runs, it calls the default Python interpreter `python`.  Due to backwards compatibility issues, in some situations you may find this behavior undesirable.  For instance, on many Linux distributions and Mac OS X, 2.7 is the default installation of Python.  If yo install PyOrient using the above command and then attempt to develop an application that uses Python 3.5, you'll find the `pyorient` module unavailable.

In the event that you don't know what version you have installed, you can run this command to see:

<pre>
$ <code class="lang-sh userinput">python --version</code>
Python 2.7.11
</pre>

To install PyOrient for a specific version of Python, call pip as a module for the desired Python interpreter.  For instance,

<pre>
$ <code class="lang-sh userinput">python3 -m pip install pyorient --user</code>
</pre>


### Building from Source

In the event that you would like to contribute to the [PyOrient Project](https://github.com/orientechnologies/pyorient) or for whatever reason would prefer to work from a development release of PyOrient, you can clone the repository from GitHub and install it on your system, again either at a local- or system-level.

You can clone the repository using the following command:

<pre>
$ <code class="lang-sh userinput">git clone https://github.com/orientechnologies/pyorient</code>
</pre>

Then from within that directory you can install PyOrient using the setup script:

- To install PyOrient locally, run the following command:

  <pre>
  $ <code class="lang-sh userinput">python setup.py install --user</code>
  </pre>

- To install PyOrient globally, instead run this command:

  <pre>
  $ <code class="lang-sh userinput">sudo python setup.py install</code>
  </pre>

Notice that these commands utilize the default Python interpreter, whichever version that happens to be on your system.  This may create issues if you intend to use PyOrient with a version of Python that is not your system default.  To run the installation, substitute the interpreter in the above commands with the version that you want to use.  For instance,

<pre>
$ <code class="lang-sh userinput">python3 setup.py install --user</code>
</pre>


#### Running Tests

When working with development releases, it is advisable that you run tests after installing PyOrient.  If you would like to contribute code to the project, it's required that you also develop tests for your contributions, to avoid issues in future development.

Testing PyOrient requires that you have Apache Maven and Nose installed on your system.  To run the test, first bootstrap OrientDB by running the following command from the `pyorient/` directory:

<pre>
$ <code class="lang-sh userinput">./ci/start-ci.sh</code>
</pre>

Running this command downloads the latest version of OrientDB into a local directory then makes some changes to its configuration file and installs a database for use in the test.  Once it's done, you can run the test:

<pre>
$ <code class="lang-sh userinput">nosetests</code>
</pre>


## Using PyOrient

Once you have PyOrient installed you can begin to use it in your applications.  You can load it through the standard Python import system.  There are two modules available to you:

- [**PyOrient Client**](PyOrient-Client.md) The base module provides a Python wrapper to the OrientDB [Binary Protocol](../Network-Binary-Protocol.md).  To use it, add the following line to your application:

  ```py
  import pyorient
  ```

- [**PyOrient OGM**](PyOrient-OGM.md) The Object-Graph Mapper for PyOrient provides a higher-level Object Oriented Pythonic interface for Graph Databases in OrientDB.  To use it, add the following line to your application:

  ```py
  import pyorient.ogm
  ```

You may need one or both for your application, depending upon your particular needs.
