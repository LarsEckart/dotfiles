---
name: approvaltests-java
description: |
  Write and maintain Java tests using ApprovalTests snapshot testing library. Use when: (1) Writing tests with `Approvals.verify()` or similar methods, (2) Testing complex objects, JSON, XML, HTML, or collections, (3) Verifying UI components (AWT/Swing), (4) Testing with combinations of inputs, (5) Configuring reporters, scrubbers, or options, (6) Managing `.approved.` and `.received.` files, (7) Using inline approvals, or (8) Working with `.approval_tests_temp` scripts.
---

# ApprovalTests.Java

Snapshot-based testing library that simplifies assertions by comparing output to approved files.

## Maven/Gradle

```xml
<dependency>
    <groupId>com.approvaltests</groupId>
    <artifactId>approvaltests</artifactId>
    <version>26.4.0</version>
    <scope>test</scope>
</dependency>
```

```gradle
testImplementation("com.approvaltests:approvaltests:26.4.0")
```

## Core API

### Basic Verification

```java
import org.approvaltests.Approvals;
import org.approvaltests.JsonApprovals;

// Verify string/object (uses toString())
Approvals.verify("expected output");
Approvals.verify(myObject);

// Verify as JSON (for objects without good toString())
JsonApprovals.verifyAsJson(myObject);

// Verify collections/arrays
Approvals.verifyAll("label", myArray);
Approvals.verifyAll("label", myList, item -> item.toString());

// Verify with formatting
Approvals.verifyHtml("<html>...</html>");
Approvals.verifyXml("<xml>...</xml>");

// Verify exceptions
Approvals.verifyException(() -> throwingCode());
```

### Combination Approvals

Test all combinations of inputs:

```java
import org.approvaltests.combinations.CombinationApprovals;

Integer[] lengths = {4, 5, 10};
String[] words = {"Bookkeeper", "applesauce"};

CombinationApprovals.verifyAllCombinations(
    (length, word) -> word.substring(0, length),
    lengths, words
);
```

### AWT/Swing Verification

```java
import org.approvaltests.awt.AwtApprovals;

AwtApprovals.verify(myComponent);      // Component
AwtApprovals.verify(myImage);          // Image/BufferedImage
AwtApprovals.verifySequence(5, i -> createFrame(i)); // Animation
```

## Options

Configure verification behavior via `Options`:

```java
import org.approvaltests.core.Options;

// Chain options fluently
new Options()
    .withReporter(DiffReporter.INSTANCE)
    .withScrubber(Scrubbers::scrubGuid)
    .forFile().withExtension(".json");

// Use in verify
Approvals.verify(output, new Options().forFile().withExtension(".html"));
```

## Reporters

Reporters launch diff tools on failure. Configure via:

### 1. Options (highest priority)

```java
Approvals.verify(obj, new Options().withReporter(IntelliJReporter.INSTANCE));
```

### 2. Annotations

```java
@UseReporter(DiffReporter.class)           // Single
@UseReporter({DiffReporter.class, ClipboardReporter.class}) // Multiple
public class MyTest { }
```

### 3. PackageSettings.java

```java
public class PackageSettings {
    public static DiffReporter UseReporter = DiffReporter.INSTANCE;
}
```

### 4. Environment Variable

`APPROVAL_TESTS_USE_REPORTER=AutoApproveReporter` or `MeldMergeReporter`

### Common Reporters

- `DiffReporter.INSTANCE` - Auto-detect installed diff tool
- `IntelliJReporter.INSTANCE` - IntelliJ IDEA
- `VisualStudioCodeReporter.INSTANCE` - VS Code
- `ClipboardReporter.INSTANCE` - Copy approve command to clipboard
- `QuietReporter.INSTANCE` - Console output only (CI)
- `AutoApproveReporter.INSTANCE` - Auto-approve changes

## Scrubbers

Remove non-deterministic content for stable tests:

```java
import org.approvaltests.scrubbers.*;

// GUIDs
new Options(Scrubbers::scrubGuid)

// Dates
new Options().withScrubber(DateScrubber.getScrubberFor("00:00:00"))

// Regex
new Options(new RegExScrubber("\\d+", "[number]"))

// Multiple scrubbers
Scrubber combined = Scrubbers.scrubAll(guidScrubber, dateScrubber, portScrubber);
```

## Inline Approvals

Store expected value in test source (good for small outputs):

```java
@Test
void testSmallOutput() {
    String expected = """
        line 1
        line 2
        """;
    Approvals.verify(computeOutput(), new Options().inline(expected));
}
```

## File Naming

Files named: `ClassName.methodName.approved.txt` (or `.json`, `.html`, etc.)

- `.approved.*` - Committed to source control (the expected output)
- `.received.*` - Generated on test failure (actual output)

**Git config:** Add `*.approved.* binary` to `.gitattributes` to preserve line endings.

## Approving Results

When a test fails, approve by:

1. Rename `.received.` file to `.approved.`
2. Run the `mv` command shown in output (also copied to clipboard)
3. Use diff tool's "use right side" feature

## Bulk Actions (.approval_tests_temp scripts)

ApprovalTests creates helper scripts in `.approval_tests_temp/`:

### approve_all.py

Approve all pending changes at once:

```bash
python .approval_tests_temp/approve_all.py
```

### remove_abandoned_files.py

Remove `.approved.*` files for deleted tests:

```bash
python .approval_tests_temp/remove_abandoned_files.py
```

## Test Framework Support

Works with JUnit 3, 4, 5 and TestNG. No special configuration needed.

## Best Practices

1. **Commit `.approved.` files** - They are your expected output
2. **Never commit `.received.` files** - Add to `.gitignore`
3. **Use scrubbers** for timestamps, GUIDs, ports, etc.
4. **Use inline approvals** for small, stable outputs
5. **Use JSON verification** for objects without good `toString()`
6. **Use CombinationApprovals** to test many input combinations efficiently
