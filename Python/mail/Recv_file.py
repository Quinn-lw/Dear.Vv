smtp_server = 'smtp.4px.com'
mail_user = 'wangkun@4px.com'
mail_pass = '2019@4PX.COM'

import imaplib
import email

class Email():
    ASC = 1
    DESC = 2
    DEFAULT_IMAP_SERVER = "smtp.4px.com"

    def __init__(self, mail_user, mail_pass, smtp_server=DEFAULT_IMAP_SERVER):
        self.mail_user = mail_user
        self.mail_pass = mail_pass
        self.smtp_server = smtp_server
        self.login()
        
    def login(self):
        self.mail_obj = imaplib