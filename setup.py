#!/usr/bin/env python
import os
import sys

from setuptools import find_packages, setup


if sys.version_info < (3, 8) or sys.version_info >= (3, 12):
    print('Error: dbt-teradata does not support this version of Python.')
    print('Please install Python 3.8 or higher but less than 3.12.')
    sys.exit(1)


this_directory = os.path.abspath(os.path.dirname(__file__))
with open(os.path.join(this_directory, 'README.md')) as f:
    long_description = f.read()


package_name = "dbt-teradata-utils"
package_version = "0.0.1a"
description = """The Teradata utils for dbt (data build tool)"""


setup(
    name=package_name,
    version=package_version,

    description=description,
    long_description=long_description,
    long_description_content_type='text/markdown',

    author="Teradata Corporation",
    author_email="developers@teradata.com",
    url="https://github.com/Teradata/dbt-teradata-utils",
    packages=find_packages(exclude=['dbt_utils_integration_tests_howto']),
    package_data={
        'dbt.include.teradata': [
            'macros/*.sql'
        ],
    },
    install_requires=[
        "dbt-core>=1.7.0,<2.0.0",
        "teradatasql>=16.20.0.0",
    ],
    classifiers=[
        'Development Status :: 5 - Production/Stable',

        'License :: OSI Approved :: Apache Software License',

        'Operating System :: Microsoft :: Windows',
        'Operating System :: MacOS :: MacOS X',
        'Operating System :: POSIX :: Linux',

        'Programming Language :: Python :: 3.8',
        'Programming Language :: Python :: 3.9',
        'Programming Language :: Python :: 3.10',
        'Programming Language :: Python :: 3.11',
    ],
    python_requires=">=3.8,<3.12",
)
