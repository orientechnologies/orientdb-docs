
# PyOrient OGM - Scripts

In addition to the [Client](PyOrient-Client.md) and the standard OGM methods shown above, you can also operate on the OrientDB database.  This provides you with basic support for [Gremlin](../gremlin/Gremlin.md) graph traversal, through Groovy scripts.

## Working with Scripts

In order to use scripts in your application, you first need to add them to the OGM `Graph` class.  Once added, you can call them from within your application, using the `gremlin()` method.

For instance, say that you want to add a set of Groovy scripts from the `scripts/` directory.  You might use something like this to do so:

```py
# Module Imports
import pathlib
from pyorient.groovy import GroovyScripts

# Iterate through scripts/
for path in pathlib.Path('scripts/').iterdir():

   # Check if Groovy Script
   if path.is_file() and path.suffix == '.groovy':

      # Add Script
      graph.scripts.add(GroovyScripts.from_file(str(path)))
```

Here, your application uses the `pathlib` module to iterate over each file and directory in the `scripts/` directory.  For each instance, it checks whether the instance is a file with the `.groovy` extension.  It then parses out functions found in these files and adds them to the `scripts` attribute. 


### Using Scripts

Scripts that you add to the `scripts` attribute are callable through the `gremlin()` method.  For the example of the smart home application, let's say that you have a `compile_data()` function that compiles sensor data in building charts for the web interface.  You give it the type of sensor you want to read and it iterates through each zone as data points for the charts.

```py
pollen_chart = graph.gremlin('compile_data', 'pollen')
```

This runs the `compile_data()` function, passing the string `pollen` to it, to indicate that you would like to compile data from pollen sensors.  It then returns the results to the `pollen_chart` variable.

>**NOTE**: In the event that you need namespacing, both the `add()` and `gremlin()` methods allow you to set `namespace` arguments.  Using this, you can separate different functions with the same name.
