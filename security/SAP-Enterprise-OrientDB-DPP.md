# SAP Enterprise OrientDB Data Protection and Privacy Approach for Products #
The purpose of this document is to describe the approach and capabilities provided by SAP Enterprise OrientDB which can be used by applications and customers to comply with data protection regulations like the EU General Data Protection Regulation (GDPR).

The document also does not provide how-tos, guidelines, or rules on how to be compliant to data protection and privacy regulations. This needs to be done by the customer based on their own data protection and privacy requirements and applicable regulations.

Data protection and privacy regulations are applicable to the storage and processing and transfer of data regarded as personal data or even sensitive personal data.  Data protection in general is applicable to all types of personal data.

However, some of the details on how data protection requirements are applied in practice can differ, depending on the type of data. In the context of SAP Enterprise OrientDB we distinguish between two types of data:

- **Application Data** i.e. data that comes from applications to be stored, processed, and managed by the data-structures (e.g., database classes) and features provided by SAP Enterprise OrientDB. The semantics, content (social security number, product ID, health data) and relation (e.g., which class makes up a business object like customer) of this data or what regulations need to apply (e.g., retention periods) are under the control of the application. SAP Enterprise OrientDB itself is agnostic to the semantics and only sees the technical representation of the data in SAP Enterprise OrientDB technical objects (e.g. classes). Therefore, the application is responsible to ensure that the data is processed in compliance with data protection regulations and the requirements defined by SAP product standards. SAP Enterprise OrientDB enables the applications to comply by providing appropriate capability and features. The details on what SAP Enterprise OrientDB offers for the specific requirements are described later in this document.
- **Operational Data** is the data which is collected with the purpose to ensure correct operation, maintenance, and functioning of the system. Depending on the type of data it may contain personal related data. Operational data in SAP Enterprise OrientDB is stored in different places:
	- Audit Log
	- Log Files
	- System Classes
	- Backup Files
	
	This data is collected for the direct purpose of running and maintaining the operation of the SAP Enterprise OrientDB system.


# GDPR principles, SAP requirements, SAP Enterprise OrientDB Implementation #
Based on the data protection regulations SAP created a set of requirements including five corporate requirements. Some of these requirements were primarily defined for business applications. For SAP Enterprise OrientDB as a database platform we had to find our own interpretation of these requirements.

Processing of Personal Data – Legal Ground
One of the key principles of DPP is that there needs to be an explicit legal ground to process personal data.

Providing the legal ground is not a technical topic but a process and legal topic that needs to be addressed independently from the technology. Therefore, those requirements do not translate into technical product requirements.


|---|---|---|
|Consent|Where processing is based on the data subject's consent, the controller should be able to demonstrate that the data subject has given consent to the processing operation. (GDPR rec. 42, sentence 1.)|Not Applicable|
|Contract|Processing should be lawful where it is necessary in the context of a contract or the intention to enter into a contract. (GDPR rec. 44)|Not Applicable|
|Legal Obligation|Business software based examples: tax reporting, income tax reporting, reporting for social insurance|Not Applicable|
|Protect Vital Interest|The processing of personal data should also be regarded to be lawful where it is necessary to protect an interest which is essential for the life of the data subject or that of another natural person. (GDPR rec. 46 sentence 1)|Not Applicable|
|Public Interest|Where processing is … necessary for the performance of a task carried out in the public interest or in the exercise of official authority, the processing should have a basis in Union or Member State law. (GDPR rec. 45 sentence 1)|Not Applicable|
|Legitimate Interest|Proofing a legitimate interest is subject to a careful legal consideration whether “fundamental rights and freedoms of the data subject” are not overriding such an interest. (GDPR rec. 47)|Not Applicable|

## Complements of the General Right - Rights of the Data Subject ##
Data protection regulations define very specific rights to the data subject. Anyone wanting to process data on one of the legal grounds defined above needs to ensure those rights. That means SAP software has to enable customers to run their applications according to those regulations.

Not all requirements can be translated into technical requirements or by technical means alone. However, some of those requirements need to be technically supported by SAP software and those are translated into explicit requirements in the SAP security product standard. The following table lists those requirements and the following sections define the way SAP Enterprise OrientDB deals with those requirements.

|Requirement|Content|
|---|---|
|Notification|The ability to inform the data subject if the data is used for a different purpose.|
|Information|The data subject’s right to get information on the data undergoing processing concerning them.|
|Correction|Personal data has to be true and to be corrected (latest after request).|
|Erasure|The ability to delete personal data when all retention periods have passed.<br><br>The ability to block personal data as soon as the primary purpose has passed and the residence time has elapsed.|
|Data Portability|The right of the data subject to receive his personal data in a structured, commonly used, and machine-readable format.|
|Automated Decisions|The data subject has the right that any automated decision can become subject to manual interference.|

### SEC-255: Provide a retrieval function which can be used to inform the data subjects about the personal data stored about them ###
The requirement specifically applies to applications. Personal application data stored inside SAP Enterprise OrientDB classes (user information) can be displayed by using OrientDB SQL queries. Since only applications have the knowledge as to which classes contain personal data, they are responsible for implementing report and display functions using such standard capabilities provided by SAP Enterprise OrientDB.

The requirement does not apply to operational data.  Backups, logs, and trace files at this time are not explicitly listed in the EU GDPR and have an agreed exception in the German Data Protection Regulation.

### SEC-256: Erase personal data when all applicable retention periods have expired ###
SAP Enterprise OrientDB supports the deletion (erasure) of application data in classes using SQL deletion commands or API commands. After the data has been deleted, this operation cannot be undone. Applications must make use of these commands to implement deletion requirements.

Retention periods, deletion of data without affecting application functionality (e.g. referential integrity) are dependent on the business context, application architecture, etc., and need to be managed by the application. The application needs to implement these rules using the SQL deletion commands or equivalent OrientDB APIs.

Applications can implement blocking of data using SAP Enterprise OrientDB methods like record-based security and masking or separating the data using OrientDB SQL Predicate Security.

Operational data: Deletion of specific records (e.g. all records of a specific person) does not apply to operational data.  However, still this data is also subject to deletion/retention requirements.  Those timelines usually apply to the complete data set (e.g. all logs older than x days need to be deleted).

Backup: Following standard practice, deletion of individual personal data is not enforced in backups. Common practice is that deleted data will disappear from backups following typical backup-rotation mechanisms. Explicitly deleting personal data from backups is therefore outside the scope of SAP Enterprise OrientDB’s data protection approach and would need to be managed by the customer dependent on their backup and DPP requirements.

Physical deletion: After data is deleted using, for example the SQL DELETE statement, the respective storage area is marked as free but is not immediately overwritten. The associated storage area will only be overwritten once new data is stored in the respective cluster. As SAP Enterprise OrientDB writes the page as a whole to the record cluster, the deleted, but not overwritten memory areas are also stored to disk in binary format. It is therefore feasible that fragments of the deleted data could under certain circumstances or for a certain period of time be reconstructed. Prerequisite is direct access to the database files in the file system as well as access to the encryption key in case the encryption-at-rest feature of SAP Enterprise OrientDB is used.

An analysis has shown that other DB vendors face the same problem and that there are no solutions on the market to address the complete deletion of those remaining data-fragments (in literature referred to as “slack”).  Completely deleting those remains is very difficult and dependent on other factors like the storage technology used. Initial recommendation is therefore to reduce such slack. SAP Enterprise OrientDB already has a method to reduce slack by making completely unused old pages unreadable when the encryption feature is used.

Further extending physical deletion capabilities would depend on customer demand.

### SEC-254 - SAP software shall log read access to sensitive personal data ###
Applications may store sensitive personal data in SAP Enterprise OrientDB.  SAP Enterprise OrientDB provides an audit log that can track which user has accessed data records in SAP Enterprise OrientDB.

With this mechanism, audit polices can be defined to log access to classes containing sensitive personal data.

It is recommended for applications built on top of SAP Enterprise OrientDB to document clearly where sensitive information is stored so that customers, if required on SAP Enterprise OrientDB level, can define respective policies.

This does not apply to operational data.

### SEC-265 - SAP software shall log changes to personal data ###
Changes to the personal data stored in application data in SAP Enterprise OrientDB can be logged using SAP Enterprise OrientDB’s audit logging functionality.

SAP Enterprise OrientDB provides the infrastructure to define customer-specific audit log policies which log change access to defined objects in the database (issued UPDATE, DELETE, … statements).

Audit policies can be defined by the customer (administrator). Applications built on top of SAP Enterprise OrientDB should provide guidelines for customers on how to set-up appropriate log policies, for example by providing information on which classes contain relevant information.

### General Log Requirements (valid for SEC-265, SEC-254) ###
SAP Enterprise OrientDB provides a common policy-based logging infrastructure that can be used by all applications running on SAP Enterprise OrientDB to log actions on data access as well as administrative or security related events in SAP Enterprise OrientDB.  As a target for storing the log trail, SAP Enterprise OrientDB currently supports writing the information to the syslog infrastructure of the underlying operating system or a special log class within the System database (appropriately protected by authorization).

Syslog integration allows customers to:

- Implement physical segregation of duty by sending the log data to their existing log infrastructure, which means that the log data cannot be changed by database administrators
- Use their established log infrastructure and tools including the compliance rules already implemented in this infrastructure
- Use their own established tools for analyzing the log entries

This approach is very well received by customers and meets their expectations on log handling.

Logging into tables allows customers to:
- Store data within the database itself in specially protected classes
- Use standard SQL tooling for log analysis

The log table is a specially protected system table.

Log viewing, deletion, and retention have to be managed by the customer and cannot be provided by SAP Enterprise OrientDB.
