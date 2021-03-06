% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/DefineSummariesClass.R
\name{def.sW}
\alias{+.DefineSummariesClass}
\alias{def.sA}
\alias{def.sW}
\title{Define Summary Measures sA and sW}
\usage{
def.sW(...)

def.sA(...)

\method{+}{DefineSummariesClass}(sVar1, sVar2)
}
\arguments{
\item{...}{Named R expressions or character strings that specify the formula for creating the summary measures.}

\item{sVar1}{An object returned by a call to \code{def.sW} or \code{def.sA} functions.}

\item{sVar2}{An object returned by a call to \code{def.sW} or \code{def.sA} functions.}
}
\value{
R6 object of class \code{DefineSummariesClass} which can be passed as an argument to \code{eval.summaries}
 and \code{tmlenet} functions.
}
\description{
Define and store summary measures \code{sW} and \code{sA} that can be later processed inside
 \code{\link{eval.summaries}} or \code{\link{tmlenet}} functions.
 \code{def.sW} and \code{def.sA} return an \code{R6} object of class \code{\link{DefineSummariesClass}}
 which stores the user-defined summary measure functions of the baseline covariates \code{W}
 and exposure \code{A}, which can be later evaluated inside the environment of the input \code{data} data frame.
 Note that calls to \code{def.sW} must be used for defining the summary measures that are functions
 of \strong{only the baseline covariates \code{W}}, while calls to \code{def.sA} must be used
 for defining the summary measures that are functions of both, \strong{the baseline covariates \code{W}
 and exposure \code{A}}.
 Each summary measure is specified as an evaluable R expression or a string that can be parsed into
 an evaluable R expression. Any variable name that exists as a named column in the input \code{data}
 data frame can be used as part of these expressions.
 Separate calls to \code{def.sW/def.sA} functions can be aggregated into a single collection with '+' function,
 e.g., \code{def.sW(W1)+def.sW(W2)}.
 A special syntax is allowed inside these summary expressions:
 \itemize{
 \item \code{'Var[[index]]'} - will index the friend covariate values of the variable \code{Var}, e.g.,
   \code{'Var[[1]]'} will pull the covariate value of \code{Var} for the first friend, \code{'Var[[Kmax]]'}
   of the last friend, and
   \code{'Var[[0]]'} is equivalent to writing \code{'Var'} itself (indexes itself).
 }
 A special argument named \code{replaceNAw0} can be also passed to the \code{def.sW}, \code{def.sA} functions:
 \itemize{
 \item \code{replaceNAw0 = TRUE} - automatically replaces all the missing network covariate values
 (\code{NA}) with \code{0}.
 }
 One can then test the evaluation of these summary measures by either passing the returned
 \code{\link{DefineSummariesClass}} object to function \code{\link{eval.summaries}} or by calling the
 internal method \code{eval.nodeforms(data.df, netind_cl)} on the result returned by \code{def.sW} or \code{def.sA}.
 Each separate argument to \code{def.sW} or \code{def.sA} represents a new summary measure.
 The user-specified argument name defines the name of the corresponding summary measure
 (where the summary measure represents the result of the evaluation of the corresponding R expression specified by the argument).
 When a particular argument is unnamed, the summary measure name
 will be generated automatically (see Details, Naming Conventions and Examples below).
}
\section{Details}{


The R expressions passed to these functions are evaluated later inside \code{\link{tmlenet}} or
 \code{\link{eval.summaries}} functions,
 using the environment of the input data frame, which is enclosed within the user-calling environment.

Note that when observation \code{i} has only \code{j-1} friends, the \code{i}'s value of \code{"W_netFj"} is
 automatically set to \code{NA}.
 This can be an undersirable behavior in some circumstances, in which case one can automatically replace all such
 \code{NA}'s with \code{0}'s by setting the argument \code{replaceMisVal0 = TRUE} when calling functions
 \code{def.sW} or \code{def.sA}, i.e., \code{def.sW(W[[1]], replaceMisVal0 = TRUE)}.
}

\section{Naming conventions}{

Naming conventions for summary measures with no user-supplied name (e.g., \code{def.sW(W1)}).

....................................
 \itemize{
 \item If only one unique variable name is used in the summary expression (only one parent), use the variable
   name itself to name the summary measure;
 \item If there is more than 1 unique variable name (e.g., \code{"W1+W2"}) in the summary expression, throw an exception
   (user must always supply summary measure names for such expressions).
 }

Naming conventions for the evaluation results of summary measures defined by \code{def.sW} & \code{def.sA}.

....................................
 \itemize{
 \item When summary expression evaluates to a vector result, the vector is first converted to a 1 col matrix,
   with column name set equal to the summary expression name;
 \item When the summary measure evaluates to a matrix result and the expression has only one unique variable
   name (one parent), the matrix column names are generated as follows: for the expressions such as \code{"Var"}
   or \code{"Var[[0]]"}, the column names \code{"Var"} are assigned
   and for the expressions such as \code{"Var[[j]]"}, the column names \code{"Var_netFj"} are assigned.
 \item When the summary measure (e.g., named \code{"SummName"}) evaluates to a matrix and either: 1) there is
   more than one unique variable name used inside the expression (e.g., \code{"A + 2*W"}),
   or 2) the resulting matrix has empty (\code{""}) column names, the column names are assigned according to the
   convention:
   \code{"SummName.1"}, ..., \code{"SummName.ncol"},
   where \code{"SummName"} is replaced by the actual summary measure name and \code{ncol} is the number of columns
   in the resulting matrix.
 }
}
\examples{
#***************************************************************************************
# LOAD DATA, LOAD A NETWORK
#***************************************************************************************
data(df_netKmax6) # load observed data
head(df_netKmax6)
data(NetInd_mat_Kmax6)  # load the network ID matrix
netind_cl <- simcausal:::NetIndClass$new(nobs = nrow(df_netKmax6), Kmax = 6)
netind_cl$NetInd <- NetInd_mat_Kmax6
head(netind_cl$nF)

#***************************************************************************************
# Example. Equivalent ways of defining the same summary measures.
# Note that 'nF' summary measure is always added to def.sW summary measures.
# Same rules apply to def.sA function, except that 'nF' is not added.
#***************************************************************************************
def_sW <- def.sW(W1, W2, W3)
def_sW <- def.sW("W1", "W2", "W3")
def_sW <- def.sW(W1 = W1, W2 = W2, W3 = W3)
def_sW <- def.sW(W1 = W1[[0]], W2 = W2[[0]], W3 = W3[[0]]) # W1[[0]] just means W1
def_sW <- def.sW(W1 = "W1[[0]]", W2 = "W2[[0]]", W3 = "W3[[0]]")

# evaluate the sW summary measures defined last:
resmatW <- def_sW$eval.nodeforms(data.df = df_netKmax6, netind_cl = netind_cl)
head(resmatW)

# define sA summary measures and evaluate:
def_sA <- def.sA(A, AW1 =A*W1)
resmatA <- def_sA$eval.nodeforms(data.df = df_netKmax6, netind_cl = netind_cl)
head(resmatA)

#***************************************************************************************
# Summary measures based on network (friend) values of the variable (matrix result).
#***************************************************************************************
# W2[[1:Kmax]] means vectors of W2 values of friends (W2_netF_j), j=1, ..., Kmax:
def_sW <- def.sW(netW2 = W2[[0:Kmax]], W3 = W3[[0]])
# evaluation result is a matrix:
resmat <- def_sW$eval.nodeforms(data.df = df_netKmax6, netind_cl = netind_cl)
# The mapping from the summary measure names to actual evaluation column names:
def_sW$sVar.names.map

# Equivalent way to define the same summary measure is to use syntax '+'
# and omit the names of the two summary measures above
# (the names are assigned automatically as "W2" for the first matrix W2[[0:Kmax]]
# and "W3" for the second summary measure "W3[[0]]")
def_sW <- def.sW(W2[[0:Kmax]]) + def.sW(W3[[0]])
resmat2 <- def_sW$eval.nodeforms(data.df = df_netKmax6, netind_cl = netind_cl)
head(resmat2)
# The mapping from the summary measure names to actual evaluation column names:
def_sW$sVar.names.map

#***************************************************************************************
# Define new summary measure as a sum of friend covariate values of W3:
#***************************************************************************************
# replaceNAw0 = TRUE sets all the missing values to 0
def_sW <- def.sW(sum.netW3 = sum(W3[[1:Kmax]]), replaceNAw0 = TRUE)

# evaluation result:
resmat <- def_sW$eval.nodeforms(data.df = df_netKmax6, netind_cl = netind_cl)

#***************************************************************************************
# More complex summary measures that involve more than one covariate:
#***************************************************************************************
# replaceNAw0 = TRUE sets all the missing values to 0
def_sW <- def.sW(netW1W3 = W3[[1:Kmax]]*W3[[1:Kmax]])

# evaluation result (matrix):
resmat <- def_sW$eval.nodeforms(data.df = df_netKmax6, netind_cl = netind_cl)
# the mapping from the summary measure names to the matrix column names:
def_sW$sVar.names.map

#***************************************************************************************
# Vector results, complex summary measure (more than one unique variable name):
# NOTE: all complex summary measures must be named, otherwise an error is produced
#***************************************************************************************
# named expression:
def_sW <- def.sW(sum.netW2W3 = sum(W3[[1:Kmax]]*W2[[1:Kmax]]), replaceNAw0 = TRUE)
mat1a <- def_sW$eval.nodeforms(data.df = df_netKmax6, netind_cl = netind_cl)

# the same unnamed expression (trying to run will result in error):
def_sW <- def.sW(sum(W3[[1:Kmax]]*W2[[1:Kmax]]), replaceNAw0 = TRUE)
\dontrun{
  mat1b <- def_sW$eval.nodeforms(data.df = df_netKmax6, netind_cl = netind_cl)  
}

#***************************************************************************************
# Matrix result, complex summary measure (more than one unique variable name):
# NOTE: all complex summary measures must be named, otherwise an error is produced
#***************************************************************************************
# When more than one parent is present, the columns are named by convention:
# sVar.name\%+\%c(1:ncol)

# named expression:
def_sW <- def.sW(sum.netW2W3 = W3[[1:Kmax]]*W2[[1:Kmax]])
mat1a <- def_sW$eval.nodeforms(data.df = df_netKmax6, netind_cl = netind_cl)

# the same unnamed expression (trying to run will result in error):
def_sW <- def.sW(W3[[1:Kmax]]*W2[[1:Kmax]])
\dontrun{
  mat1b <- def_sW$eval.nodeforms(data.df = df_netKmax6, netind_cl = netind_cl)
}

#***************************************************************************************
# Iteratively building higher dimensional summary measures using '+' function:
#***************************************************************************************
def_sW <- def.sW(W1) +
          def.sW(netW1 = W2[[1:Kmax]]) +
          def.sW(sum.netW1W3 = sum(W1[[1:Kmax]]*W3[[1:Kmax]]), replaceNAw0 = TRUE)

# resulting matrix of summary measures:
resmat <- def_sW$eval.nodeforms(data.df = df_netKmax6, netind_cl = netind_cl)
# the mapping from the summary measure names to the matrix column names:
def_sW$sVar.names.map

#***************************************************************************************
# Examples of summary measures defined by def.sA (functions of baseline and treatment)
#***************************************************************************************
def_sA <- def.sA(sum.netAW2net = sum((1-A[[1:Kmax]]) * W2[[1:Kmax]]),
                  replaceNAw0 = TRUE) +
          def.sA(netA = A[[0:Kmax]])

resmat <- def_sA$eval.nodeforms(data.df = df_netKmax6, netind_cl = netind_cl)
def_sW$sVar.names.map

#***************************************************************************************
# More summary measures for sA
#***************************************************************************************
def_sA <- def.sA(netA = "A[[0:Kmax]]") +
          def.sA(sum.AW2 = sum((1-A[[1:Kmax]])*W2[[1:Kmax]]), replaceNAw0 = TRUE)

resmat <- def_sA$eval.nodeforms(data.df = df_netKmax6, netind_cl = netind_cl)
def_sW$sVar.names.map

#***************************************************************************************
# Using eval.summaries to evaluate summary measures for both, def.sW and def.sA
# based on the (O)bserved data (data.frame) and network
#***************************************************************************************
def_sW <- def.sW(netW2 = W2[[1:Kmax]]) +
          def.sW(netW3_sum = sum(W3[[1:Kmax]]), replaceNAw0 = TRUE)
            
def_sA <- def.sA(sum.AW2 = sum((1-A[[1:Kmax]])*W2[[1:Kmax]]), replaceNAw0 = TRUE) +
          def.sA(netA = A[[0:Kmax]])

data(df_netKmax6) # load observed data
data(NetInd_mat_Kmax6)  # load the network ID matrix
res <- eval.summaries(sW = def_sW, sA = def_sA, Kmax = 6, data = df_netKmax6,
                      NETIDmat = NetInd_mat_Kmax6, verbose = TRUE)

# Contents of the list returned by eval.summaries():
names(res)
# matrix of sW summary measures:
head(res$sW.matrix)
# matrix of sA summary measures:
head(res$sA.matrix)
# matrix of network IDs:
head(res$NETIDmat)
# Observed data (sW,sA) stored as "DatNet.sWsA" R6 class object:
res$DatNet.ObsP0
class(res$DatNet.ObsP0)
}
\seealso{
\code{\link{eval.summaries}} for
 evaluation and validation of the summary measures,
 \code{\link{tmlenet}} for estimation,
 \code{\link{DefineSummariesClass}} for details on how the summary measures are stored and evaluated.
}

