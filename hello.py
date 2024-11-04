import nfc
clf = nfc.ContactlessFrontend('usb')

def connected(tag):
    print(tag.ndef.records[0])

clf.connect(rdwr={'on-connect': connected})