# Test Process#spawn redirection options

The purpose of this test is to show a difference in how the TruffleRuby `Process#spawn`
(and related methods) implement resolving the redirection option values differently than
MRI or JRuby.

MRI and JRuby will call `#to_io` on the object passed as the value for the redirection
options and TruffleRuby does not.

`test_spec.rb` tests that Process Spawn tries to convert the value of redirect options like  `out:` and
`err:` to an IO object before failing.

In this test, an object is passed to `Process#spawn` that is not an `IO` object and does not
respond to `#fileno` but does respond to `#to_io`.

The test fails if `#to_io` is not called.

MRI and JRuby call `#to_io` to get the `IO` object to use. TruffleRuby does not.
