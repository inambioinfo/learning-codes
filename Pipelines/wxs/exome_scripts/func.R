MultiSetFun = function(fun, x) {
  # performs a set function (e.g. intersect, setdiff) on x
  # where x is a list of vectors of the same type but not necessarily the same length
  
  fun = tolower(fun)
  
  this.intersect = function(M, v) {
    return(names(which(rowSums(M) == sum(v))))
  }
  
  this.setdiff = function(M, v) {
    D = lapply(v, function(i){
      names(which(rowSums(M) == i))
    })
    names(D) = colnames(M)
    return(D)
  }
  
  this.union = function(M, v) {
    return(rownames(M))
  }
  
  # concatenate all unique elements in x - this is effectively a union
  U = sort(unique(do.call('c', unname(x))))
  
  # set truth map, (i,j) is true if element i is in set j
  M = as.matrix(as.data.frame(lapply(x, function(l){U %in% l})))
  rownames(M) = U
  
  # apply column values
  v = 2^seq(0, ncol(M)-1)
  M = t(t(M) * v)
  
  return(
    switch(fun, 
           intersect = this.intersect(M,v),
           setdiff   = this.setdiff(M,v),
           union     = this.union(M,v),
           NULL) )
  
}