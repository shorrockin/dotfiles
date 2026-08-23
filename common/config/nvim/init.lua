require("cs")

-- tries to load our work specific module, stored in a separate directory
-- if it exists. if it doesn't then we'll just continue on. useful when
-- we have vim config we don't want to store in the public space.
pcall(require, "private")
