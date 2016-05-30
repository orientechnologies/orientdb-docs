#Backup Management

Studio 2.2 Enterprise Edition includes a new **Backup Manager** that allow you to schedule and perform your backups and easily 
execute and manage restores you may need.
You can enjoy this functionality by reaching the panel in the Server Management area, this is what you will find:

<fresh scheduler image>

How you can see the panel is divided into two sections, on the left side you cane schedule your backups, on the right side on 
the calendar you can check:
- the executed tasks (backup or restore)
- the scheduled backups
- eventual error raised during the execuion of a task

Now let's see how you can schedule your backups.

## Backup scheduling

On the left you can find all the settings for your backup scheduling.

<left-panel with db, path and retention selected>

As first thing **choose the database** that you want backup. In the example above we have chosen the GratefulDeadConcerts
database.
Then you must specify the **output directory** where you want to save your backups and the **retention days** of your backups.
Now you must select the **backup mode** you want to use:
- **Full backup**
- **Incremental Backup**
- **Full + Incremental Backup**

These the modes will be analysed further.

Once you have chosen you desired backup mode, you have to chose the **backup period** that indicates the time you want to
wait between each backup and the next one.
Eventually you must flag the **Enabled** checkbox and click on the **Save** button in order to start the scheduling of the 
backups according to your chosen settings.

Below we will examine briefly the three different backup strategies.

###Full backup

###Incremental Backup

###Full + Incremental Backup
