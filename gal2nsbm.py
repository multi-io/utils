#!/usr/bin/python

## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.

## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.

## You should have received a copy of the GNU General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

# Copyright 2001 by Lennart Poettering <mz67616c6d61726b@poettering.de>
# adapted to Netscape Bookmarks by Olaf Klischat <olaf.klischat@gmail.com>
# This script will create a HTML page of your Galeon XML Bookmarks

# Further information, usage examples and current versions may be found on
# http://www.stud.uni-hamburg.de/users/lennart/projects/galmark/

# You might want to change the first line to adapt it to your local
# python installation

import sys, string, re, time, locale
from xml.sax import make_parser, handler
from xml.sax.saxutils import *

def get_uniqe_id():
    import random
    return 'NC:BookmarksRoot#$%08x' % (random.random() * 0x7fffffff)

class myHandler(handler.ContentHandler):
    
    def startDocument(self):

        #print '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'
        #print '<html>\n<head>\n<title>Galeon Bookmarks for %s</title>\n<body bgcolor="white" text="black" link="red" alink="red" vlink="red">\n<a name="top"/>' % os.environ['USER']
        print '<!DOCTYPE NETSCAPE-Bookmark-file-1>'
        print '<!-- This is an automatically generated file.'
        print 'It will be read and overwritten.'
        print 'Do Not Edit! -->'
        print '<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">'
        print '<TITLE>Bookmarks</TITLE>'
        print '<H1>Bookmarks</H1>'
        print "<DL><p>"
        self._level = 0
        self._num = [0]
  
    def endDocument(self):

        #print '<small><i>Produced with <a href="http://www.stud.uni-hamburg.de/users/lennart/projects/galmark/galmark.html">galmark.py</a> by Lennart Poettering 2001</i></small>'
        #print '</body>\n</html>\n'
        print "</DL><p>"
    
    def startElement(self, name, attrs):

        if name == "folder" and attrs.has_key("name"):

            self._num[self._level] += 1
            self._level += 1
            self._num.append(0)

            if (self._level > 1):
                print '<DT><H3 ADD_DATE="1049880984" ID="%s">%s</H3>' % (get_uniqe_id(), self.rape_name(attrs["name"]))
                print '<DL><p>'

        elif name == "site" and attrs.has_key("name") and attrs.has_key("url"):

            u = attrs["url"].encode("iso8859-1")

            #d = ""
            #if attrs.has_key("time_added") :
            #    d = " - %s" % time.strftime("%x", time.gmtime(int(attrs["time_added"])))

            print '<DT><A HREF="%s" ADD_DATE="1049880984" LAST_VISIT="1049880984" LAST_MODIFIED="1049880984">%s</A>' % (escape(u), self.rape_name(attrs["name"]))
            #print '<b><a href="%s">%s</a></b>\n&nbsp;&nbsp;<small>%s%s</small><br/>' % (escape(u), self.rape_name(attrs["name"]), escape(u2), d)
        
    def endElement(self, name):

        if (name == "folder"):
            self._level -= 1
            self._num.pop()
            #print "<br>"

            if self._level >= 1:
                print "</DL><p>"
                #print '<a href="#top">top</a><br/>\n';

    def level_str(self):

        s = `self._num[1]`
        
        for i in range(2, self._level):
            s = "%s.%i" % (s, self._num[i])

        return s
        
    def rape_name(self, s):

        s = s.replace("__", "_")
        
        while (1):
            m = re.search(r'%([0-9A-F][0-9A-F])', s)

            if m == None:
                break

            s = s[:m.start()] + unichr(int(m.group(1), 16)) + s[m.end():]
            
        return escape(unicode(s.encode("iso8859-1"), "utf-8").encode("iso-8859-1"))


locale.setlocale(locale.LC_ALL, '')

parser = make_parser()
parser.setContentHandler(myHandler())
parser.parse("file://%s/.galeon/bookmarks.xml" % os.environ['HOME'])
