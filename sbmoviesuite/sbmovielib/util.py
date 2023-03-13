"""

utility routines for the sbmovie suite


djo, 5/08

"""

# ------------------------- imports -------------------------
import logging
import sys


# ------------------------- constants -------------------------
# logging level info:
loglevels = {
    "warning": logging.WARNING,
    "info": logging.INFO,
    "info-plus": 15,
    "debug": logging.DEBUG,
    }

# default parameter file info
defaultpfilename = "sbparam.txt"
defaultpfiledata = """

# default parameter file for sbconvert.py

# -- the '#' character introduces comments; blank lines are ignored
# -- keywords and values are separated by any mix of tabs and spaces;
#       you must not have tabs or spaces within a keyword
# -- unknown keywords will cause errors when the file is read
# -- if you repeat a keyword, the last value will be used
# -- if you delete or omit a keyword, the default will be used
# -- for on/off options, use: true, True, false, or False

# ----- operations control
# options for controlling what happens

# convert = False means don't do the conversion at all;
#   just calculate the background, write a bg file if 
#   asked to, and end; useful when calculating a bg image
#   to be used in converting many movies in parallel (eg,
#   on a compute cluster)
convert                     true

# writefiles = false means do the conversion and calculate 
#   the errors; but do not write out any converted movies;
#   useful if you're repeating a single
#   conversion multiple times with various paramters to 
#   find the smallest error 
writefiles                  true

# set to true to force overwriting of existing files;
#   includes both background files and converted movies 
overwrite                   false


# inputformats: what file formats to allow for input; any 
#   files of differing formats are not processed, even if
#   the filenames were explicitly given
# allowed: avi or fmf; you may also concatenate them 
#   with commas (no spaces after the commas): avi,fmf or fmf,avi
inputformats                avi


# ----- background subtraction
# use frames from all movies in similarly named sequence?
# suffix is the end of the filename; '#' indicates where 
#   the sequence index is in the name; filenames will be
#   sorted numerically (not the same as alphabetically or 
#   lexically!)
# specify sequencesuffix of "none" to use all avi files in
#   the directory in lexical order
usesequence                 false
sequencesuffix              seq#.avi

# if writebgfiles is true, a bg image file will be written for
#   each sequence; useful if you need to calculate it once
#   and use it many times; filename will be based on
#   input file or sequence, will end in -bg.pickle
writebgfiles                false

# if readbgfiles is true, bg images will attempt to be read
#   from disk; filename should match what writebgfiles will
#   output, which isn't much help to you; all you need to do
#   is not move or rename them
# if bgfilename is "default", the program will look for the 
#   filename that it would have written; if you specify a 
#   name, it will be loaded for *all* conversions!
# writebgfiles is ignored if readbgfiles is true
readbgfiles                 false
bgfilename                  default

# the rest of the options for controlling the background 
#   substitution process are not all explained here, but 
#   they are the same as in the Mtrax system
# n_bg_std_thresh_low         10
# n_bg_std_thresh_high        20

# KB: TODO: fix problems in parameter setting
# should be this?
n_bg_std_thresh_low         5
n_bg_std_thresh_high        1

# allowed: median or mean
est_algorithm               median

# allowed: standarddeviation or other
normalize_by                standarddeviation

# allowed: darkonlight, lightondark, other (other added by KB)
difference_mode             darkonlight

# how many frames to sample
bg_nframes                  100

# not sure what these mean
bg_std_min                  1.
bg_std_max                  10.


# ----- logging
# options for determining how much info is sent where

# file that summary lines are appended to:
summaryfile                 sbconvert.summary

# file that full log is appended to (see below for wordiness);
#   NOTE: host and timestamp will be added just before extension;
#   eg, "sbconvert-c03u13-200812101334.log"
logfile                     sbconvert.log

# logging levels; allowed = warning, info, info-plus, or debug
#   (from least to most wordy)
fileloglevel                info-plus
screenloglevel              info

# ----- diagnostics:
# Added by KB

# whether to compute the more involved diagnostics
# for backwards compatability, this is False by default
docomputediagnostics	    False

# width and height of window for integrating errors in pixels
diagnosticwindowsize 	    10

"""


# ------------------------- errorquit() -------------------------
def errorquit(message):
    """
    print a message and quit
    """
    
    print
    print message
    print
    
    sys.exit()
    
    # end errorquit()


# ------------------------- parsepfile() -------------------------
def parsepfile(data):
    """
    try to parse a parameter file--see above for details
    
    raises exceptions if any errors
    
    input: single long string with text from file
    output: dictionary, unvalidated
    """
    
    params = {}
    for line in data:
        line = line.strip()
        if line and line[0] != '#':
            key, value = line.split()
            params[key] = value
    
    return params
    
    # end parsepfile()

# ------------------------- validatepfile() -------------------------
def validatepfile(params):
    """
    validate parameters; some strings need adjusting before going to
    the routine we didn't write; they want spaces in values, and
    we don't support that
    
    input: parameter dictionary
    output: altered (same) dictionary; errorquits if bad values
    """
    
    # change booleans to real booleans:
    
    for keyword in ["writefiles", "overwrite", "usesequence", "convert",
        "writebgfiles", "readbgfiles", "docomputediagnostics"]:
        if params[keyword].lower() == "true":
            params[keyword] = True
        elif params[keyword].lower() == "false":
            params[keyword] = False
        else:
            util.errorquit("unknown value %s for keyword %s" % 
                (params[keyword], keyword))
    
    # fix up some backsub params:
    if params["est_algorithm"] == "median":
        params["est_algorithm"] = "Median"
    elif params["est_algorithm"] == "mean":
        params["est_algorithm"] = "Mean"
    else:
        util.errorquit("unknown est_algorithm %s" % params["est_algorithm"])
    
    if params["normalize_by"] == "standarddeviation":
        params["normalize_by"] = "Standard Deviation"
    elif params["normalize_by"] == "brightness":
        params["normalize_by"] = "Brightness"
    else:
        util.errorquit("unknown normalize_by %s" % params["normalize_by"])
    
    if params["difference_mode"] == "lightondark":
        params["difference_mode"] = "Light on Dark"
    elif params["difference_mode"] == "darkonlight":
        params["difference_mode"] = "Dark on Light"
    elif params["difference_mode"] == "other":
        params["difference_mode"] = "Other"
    else:
        util.errorquit("unknown difference_mode %s" % params["difference_mode"])
    
    # check log levels:
    for keyword in ["fileloglevel", "screenloglevel"]:
        if params[keyword] not in loglevels:
            util.errorquit("unknown log level %s" % params[keyword]) 
    
    return params
    
    # end validatepfile()

# ------------------------- writedefaultpfile() -------------------------
def writedefaultpfile():
    """
    write out default parameter file
    """
    
    f = open(defaultpfilename, 'w')
    f.write(defaultpfiledata)
    f.close()
    
    # end writedefaultpfile()

