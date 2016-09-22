import unittest
from server.utils import validate_email

def suite():
    test_suite = unittest.TestSuite()
    test_suite.addTest(UtilsTestCase('test_validate_email'))
    return test_suite

class UtilsTestCase(unittest.TestCase):
    """Tests for `services/users.py - create_user()`."""

    def test_validate_email(self):
        """Valides email"""

        self.assertTrue(validate_email('john@acme.com'))
        self.assertTrue(validate_email('John@Acme.cOm'))
        self.assertFalse(validate_email('john.com'))
