This repo tests what happens when you bundle a package name in various JavaScript bundlers. It's not necessarily obvious what should happen because there is no context for the package name. Usually path resolution happens as the result of an import statement or a require call, but in this case it happens as the result of a string passed on the command line. Import statements should apply the `import` condition while require calls should apply the `require` condition (for the `exports` field). What should happen when it's not obvious which one to apply?

Run `./test.sh` to run the tests. This is the current output:

```
========== pkg-import-require ==========
----- pkg-import-require: webpack -----
import
----- pkg-import-require: rollup -----
import
----- pkg-import-require: parcel -----
🚨 Build failed.

unknown: Entry /home/evan/foo/x/src/pkg-import-require does not exist

----- pkg-import-require: esbuild -----
✘ [ERROR] Could not resolve "pkg-import-require"

  The path "." is not currently exported by package "pkg-import-require":

    node_modules/pkg-import-require/package.json:4:13:
      4 │   "exports": {
        ╵              ^

  None of the conditions provided ("import", "require") match any of the currently active conditions
  ("browser", "default"):

    node_modules/pkg-import-require/package.json:5:9:
      5 │     ".": {
        ╵          ^

1 error



========== pkg-require ==========
----- pkg-require: webpack -----
assets by status 0 bytes [cached] 1 asset

ERROR in main
Module not found: Error: Package path . is not exported from package /home/evan/foo/x/src/node_modules/pkg-require (see exports field in /home/evan/foo/x/src/node_modules/pkg-require/package.json)

webpack 5.67.0 compiled with 1 error in 74 ms
----- pkg-require: rollup -----
(!) Plugin node-resolve: Could not resolve import "pkg-require" in undefined using exports defined in /home/evan/foo/x/src/node_modules/pkg-require/package.json.
[!] Error: Could not resolve entry module (pkg-require).
Error: Could not resolve entry module (pkg-require).
    at error (/home/evan/foo/x/node_modules/rollup/dist/shared/rollup.js:160:30)
    at ModuleLoader.loadEntryModule (/home/evan/foo/x/node_modules/rollup/dist/shared/rollup.js:22435:20)
    at async Promise.all (index 0)

----- pkg-require: parcel -----
🚨 Build failed.

unknown: Entry /home/evan/foo/x/src/pkg-require does not exist

----- pkg-require: esbuild -----
✘ [ERROR] Could not resolve "pkg-require"

  The path "." is not currently exported by package "pkg-require":

    node_modules/pkg-require/package.json:4:13:
      4 │   "exports": {
        ╵              ^

  None of the conditions provided ("require") match any of the currently active conditions
  ("browser", "default"):

    node_modules/pkg-require/package.json:5:9:
      5 │     ".": {
        ╵          ^

1 error



========== pkg-module-main ==========
----- pkg-module-main: webpack -----
module
----- pkg-module-main: rollup -----
module
----- pkg-module-main: parcel -----
🚨 Build failed.

unknown: Entry /home/evan/foo/x/src/pkg-module-main does not exist

----- pkg-module-main: esbuild -----
module



========== pkg-main ==========
----- pkg-main: webpack -----
main
----- pkg-main: rollup -----
main
----- pkg-main: parcel -----
🚨 Build failed.

unknown: Entry /home/evan/foo/x/src/pkg-main does not exist

----- pkg-main: esbuild -----
main
```

So it looks like the rules should be as follows:

1. If `exports` exists, try resolving with `import`, and fail if nothing matches
2. Otherwise, try `module`
3. Otherwise, try `main`
