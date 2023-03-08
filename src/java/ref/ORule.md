
# ORule

Provides an interface for defines resources and account access to them.

## Using Rules

To use `ORule`, first import it to your application.

```java
import com.orientechnologies.orient.core.metadata.security.ORule;
```

### Resources

`ORule` contains a nested subclass `ORule.ResourceGeneric` that defines the specific resource that the rule grants access to.

- **`BYPASS_RESTRICTED`**
- **`CLASS`**
- **`CLUSTER`**
- **`COMMAND`**
- **`COMMAND_GREMLIN`**
- **`DATABASE`**
- **`DATABASE_COPY`**
- **`DATABASE_CREATE`**
- **`DATABASE_DROP`**
- **`DATABASE_EXISTS`**
- **`DATABASE_FREEZE`**
- **`DATABASE_PASSTHROUGH`**
- **`DATABASE_RELEASE`**
- **`FUNCTION`**
- **`RECORD_HOOK`**
- **`SCHEMA`**
- **`SERVER`**
- **`SYSTEM_CLUSTERS`**


