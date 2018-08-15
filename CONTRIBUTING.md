# CONTRIBUTING

## Bug Report
- Please try `~master` version before reporting and check if the duplicate issues have not been opened yet.
- After that, you can report the bug at GitHub Issue.

## Enhancement Request
- You can request for the enhancement at GitHub Issue.

## Pull Request
- Please make commits with comment formatted this:
```
[add/remove/update/merge] Commit Description.
# empty line
Reason (If you need.)
```
### Code Style
- The code style of this project inherits [the Phobos D Style](https://dlang.org/dstyle.html).
- These rules can be ignored only when keeping them makes codes dirty.
- Brackets should be K&R style.
- In declaration, soft space must be there between the name and the arguments list.
- Soft space should be there between parens and tokens, in particular when contains 2 or more tokens.
- `@property` method should not behave heavy, in the case, use normal methods instead.
- Return type of `@property` method is not always necessary, but it's not bad to write.
- unittest is not always necessary because the most objects cannot work without initializing libraries.

```dlang
// selective import
import hoge: fuga;

// conditional operator
condition? whenTrue: whenFalse;

// function declaration
void hoge (T) ( int a )
{
}

// Bad example: sort may behave heavy.
@property children ()
{
    return _children.sort!...;
}
// Good example:
Widget[] getSortedChildren ()
{
    return _children.sort!...;
}
```
