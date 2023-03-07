#!/usr/bin/env python
import os
from setuptools import setup, find_namespace_packages

here = os.path.abspath(os.path.dirname(__file__))
with open(os.path.join(here, 'README.md')) as f:
    long_description = f.read()

setup(
    name="dbt-cratedb2",
    version="0.22.0dev1",
    description="CrateDB adapter plugin for dbt (data build tool)",
    long_description=long_description,
    long_description_content_type='text/markdown',
    author="Julio Sánchez Jiménez",
    author_email="jsnchzjmnz@gmail.com",
    url="",
    packages=find_namespace_packages(include=['dbt', 'dbt.*']),
    package_data={
        'dbt': [
            'include/cratedbadapter/dbt_project.yml',
            'include/cratedbadapter/sample_profiles.yml',
            'include/cratedbadapter/macros/*.sql',
            'include/cratedbadapter/macros/**/*.sql',
        ]
    },
    install_requires=[
        'dbt-core==0.21.0',
        'psycopg2-binary~=2.8',
    ],
    zip_safe=False,
    classifiers=[
        'Development Status :: 2 - Pre-Alpha',
        'License :: OSI Approved :: Apache Software License',
        'Operating System :: Microsoft :: Windows',
        'Operating System :: MacOS :: MacOS X',
        'Operating System :: POSIX :: Linux',
        'Programming Language :: Python :: 3.6',
        'Programming Language :: Python :: 3.7',
        'Programming Language :: Python :: 3.8',
        'Programming Language :: Python :: 3.9',
    ],
    python_requires=">=3.6.2",
)
