# HOWTO Generate a new value for jwt_signing_keys.json

Generate a new value of "k" for jwt_signing_keys.json using the following julia script:

```
# Generate a HS256 string
using Base64, Random
io = IOBuffer();
iob64_encode = Base64EncodePipe(io);
write(iob64_encode, randstring(300))
close(iob64_encode);
str = String(take!(io))
close(io)
String(base64decode(str))
str
```
