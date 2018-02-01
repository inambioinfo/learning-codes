y <- 1
f <- function(x) x + y
environment(f)
globalenv()
emptyenv()
baseenv()
typeof(f)
e <- new.env()
e$g <- function() 1
environment(sd)
pryr::where('sd')
environment(sd) %>% parent.env() %>% parent.env() %>% parent.env()

x <- 0
y <- 10
f <- function() {
  x <- 1
  g()
}
g <- function() {
  x <- 2
  h()
}
h <- function() {
  x <- 3
  x + y
}
f()

g %>% environment() %>% parent.env()
str(f)


`:)` <- 'smile'
`:)`

modify <- function(x) {
  x$a <- 2
  invisible()
}
x_l <- list()
x_l$a <- 1
modify(x_l)
x_l

x_e <- new.env()
x_e$a <- 1
modify(x_e)
x_e$a

x <- 1
e1 <- new.env()
get("x", envir = e1)
get("x", envir = e1, inherits = F)
e2 <- new.env(parent = emptyenv())
get("x", envir = e2)

my_env <- new.env(parent = emptyenv())
my_env$a <- 1

get_a <- function() {
  my_env$a
}
set_a <- function(value) {
  old <- my_env$a
  my_env$a <- value
  invisible(old)
}
get_a()
set_a(3) -> b
stop("Fatal error") # error and force to terminate execution
warning("warning something") # display potential problems
message("hell ")

withCallingHandlers()
tryCatch()
try()

# checking input is correct
# avoiding non-standard evaluation
# avoiding return different types of output


# 1. Realise that you have a bug
# 2. Make it repeatable
# 3. Figure out where it is 
# 4. Fix it and test it

f <- function(a) g(a)
g <- function(b) h(b)
h <- function(c) i(c)
i <- function(d) "a" + d
f(10)
success <- try(1 + 2)
failure <- try("a" + "b")
class(success)
#> [1] "numeric"
class(failure)


elements <- list(1:10, c(-1, 10), c(TRUE, FALSE), letters)
results <- lapply(elements, log)
#> Warning in FUN(X[[i]], ...): NaNs produced
#> Error in FUN(X[[i]], ...): non-numeric argument to mathematical function
results <- lapply(elements, function(x) try(log(x)))
#> Warning in log(x): NaNs produced

is.error <- function(x) inherits(x, "try-error")
succeeded <- !vapply(results, is.error, logical(1))

default <- NULL
try(default <- read.csv("possibly-bad-input.csv"), silent = TRUE)


show_condition <- function(code) {
  tryCatch(code,
           error = function(c) "error",
           warning = function(c) "warning",
           message = function(c) "message"
  )
}
show_condition(stop("!"))
show_condition(warning("?!"))
show_condition(message("?"))
show_condition(10 * 10)



try2 <- function(code, silent = F) {
  tryCatch(
    code,
    error = function(c) {
      c
    }
  )
}

try2(1)
try2(stop("hi")) -> te












