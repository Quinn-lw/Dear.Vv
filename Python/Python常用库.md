# Python常用库
## Requests



## urllib

## re

## mail

### Sending Email

> Simple Mail Transfer Protocol (SMTP) is a protocol, which handles sending an e-mail and routing e-mail between mail servers.

#### Syntax

```python
import smtplib

smtpObj = smtplib.SMTP( [host [, port [, local_hostname]]] )
```

Here is the detail of the parameters −

- **host** − This is the host running your SMTP server. You can specifiy IP address of the host or a domain name like tutorialspoint.com. This is an optional argument.
- **port** − If you are providing *host* argument, then you need to specify a port, where SMTP server is listening. Usually this port would be 25.
- **local_hostname** − If your SMTP server is running on your local machine, then you can specify just *localhost* the option.

An SMTP object has an instance method called **sendmail**, which is typically used to do the work of mailing a message. It takes three parameters −

- The *sender* − A string with the address of the sender.
- The *receivers* − A list of strings, one for each recipient.
- The *message* − A message as a string formatted as specified in the various RFCs.

#### Example

##### Sending Plain Text

> An e-mail requires a **From**, **To**, and a **Subject** header, separated from the body of the e-mail with a blank line.

```python
#!/usr/bin/python3

import smtplib

sender = 'from@fromdomain.com'
receivers = ['to@todomain.com']

message = """From: From Person <from@fromdomain.com>
To: To Person <to@todomain.com>
Subject: SMTP e-mail test

This is a test e-mail message.
"""

try:
   smtpObj = smtplib.SMTP('localhost')
   smtpObj.sendmail(sender, receivers, message)         
   print "Successfully sent email"
except SMTPException:
   print "Error: unable to send email"
```

##### Sending Html Text

> While sending an e-mail message, you can specify a Mime version, content type and the character set to send an HTML e-mail

```python
#!/usr/bin/python3

import smtplib

message = """From: From Person <from@fromdomain.com>
To: To Person <to@todomain.com>
MIME-Version: 1.0
Content-type: text/html
Subject: SMTP HTML e-mail test

This is an e-mail message to be sent in HTML format

<b>This is HTML message.</b>
<h1>This is headline.</h1>
"""

try:
   smtpObj = smtplib.SMTP('localhost')
   smtpObj.sendmail(sender, receivers, message)         
   print "Successfully sent email"
except SMTPException:
   print "Error: unable to send email"
```

##### Sending Attachments

To send an e-mail with mixed content requires setting the **Content-type**header to **multipart/mixed**. Then, the text and the attachment sections can be specified within **boundaries**.

A boundary is started with two hyphens followed by a unique number, which cannot appear in the message part of the e-mail. A final boundary denoting the e-mail's final section must also end with two hyphens.

The attached files should be encoded with the **pack("m")** function to have base 64 encoding before transmission.

```python
#!/usr/bin/python3

import smtplib
import base64

filename = "/tmp/test.txt"

# Read a file and encode it into base64 format
fo = open(filename, "rb")
filecontent = fo.read()
encodedcontent = base64.b64encode(filecontent)  # base64

sender = 'webmaster@tutorialpoint.com'
reciever = 'amrood.admin@gmail.com'

marker = "AUNIQUEMARKER"

body ="""
This is a test email to send an attachement.
"""
# Define the main headers.
part1 = """From: From Person <me@fromdomain.net>
To: To Person <amrood.admin@gmail.com>
Subject: Sending Attachement
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary=%s
--%s
""" % (marker, marker)

# Define the message action
part2 = """Content-Type: text/plain
Content-Transfer-Encoding:8bit

%s
--%s
""" % (body,marker)

# Define the attachment section
part3 = """Content-Type: multipart/mixed; name=\"%s\"
Content-Transfer-Encoding:base64
Content-Disposition: attachment; filename=%s

%s
--%s--
""" %(filename, filename, encodedcontent, marker)
message = part1 + part2 + part3

try:
   smtpObj = smtplib.SMTP('localhost')
   smtpObj.sendmail(sender, reciever, message)
   print "Successfully sent email"
except Exception:
   print ("Error: unable to send email")
```

### Receiving Email

Example:

```python
def checkMailAccount(server,user,password,ssl=False,port=None):
    '''
    Check Mail Account
    '''
    if not port:
        port = 995 if ssl else 110

    try:
        pop3 = poplib.POP3_SSL(server, port) if ssl else poplib.POP3(server, port)

        pop3.user(user)
        auth = pop3.pass_(password)
        pop3.quit()
    except Exception as error:
        #print "[!] chekcing {0} failed, reason:{1}".format(user, str(error))
        return False

    if "+OK" in auth:
        return True
    else:
        return False 
```

```python
def popPeek(server, user, port=110):
    '''
    A quick look of mail
    '''

    try:
        P = poplib.POP3(server, port)
        P.user(user)
        P.pass_(getpass.getpass())
    except:
        print "Failed to connect to server."
        sys.exit(1)

    deleted = 0

    try:
        l = P.list()
        msgcount = len(l[1])
        for i in range(msgcount):
            msg = i+1
            top = P.top(msg, 0)
            for line in top[1]:
                print line
            input = raw_input("D to delete, any other key to leave message on server: ")
            if input=="D":
                P.dele(msg)
                deleted += 1
        P.quit()                
        print "%d messages deleted. %d messages left on server" % (deleted, msgcount-deleted)
    except:
        P.rset()
        P.quit()
        deleted = 0
        print "\n%d messages deleted. %d messages left on server" % (deleted, msgcount-deleted)
```



```python
#!/usr/bin/env python
# coding=utf-8

import poplib
from email import parser
 
host = 'pop.163.com'
username = 'MyTest22@163.com'
password = 'xxxxxxxxx'
 
pop_conn = poplib.POP3_SSL(host)
pop_conn.user(username)
pop_conn.pass_(password)
 
#Get messages from server:
# 获得邮件
messages = [pop_conn.retr(i) for i in range(1, len(pop_conn.list()[1]) + 1)]
#print messages
 
#print "--------------------------------------------------"
# Concat message pieces:
messages = ["\n".join(mssg[1]) for mssg in messages]
#print messages
 
#Parse message intom an email object:
# 分析
messages = [parser.Parser().parsestr(mssg) for mssg in messages]
i = 0
for message in messages:
	i = i + 1
	mailName = "mail%d.%s" % (i, message["Subject"])
	f = open(mailName + '.log', 'w');
	print >> f, "Date: ", message["Date"]
	print >> f, "From: ", message["From"]
	print >> f, "To: ", message["To"]
	print >> f, "Subject: ", message["Subject"]
	print >> f, "Data: "
	j = 0
	for part in message.walk():
		j = j + 1
		fileName = part.get_filename()
		contentType = part.get_content_type()
		# 保存附件
		if fileName:
			data = part.get_payload(decode=True)
			fileName = "%s.%d.%s" % (mailName, j, fileName)
			fEx = open(fileName, 'wb')
			fEx.write(data)
			fEx.close()
		elif contentType == 'text/plain' or contentType == 'text/html':
			#保存正文
			data = part.get_payload(decode=True)
			print >> f, data
 
	f.close()
pop_conn.quit()
```



