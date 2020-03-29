#!/usr/bin/env python
import os
import json
import xml.etree.ElementTree as ET

vraFacts = "/opt/puppetlabs/facter/facts.d/vrafacts.json"
factDir = os.path.dirname(vraFacts)
if not os.path.exists(factDir):
	os.makedirs(factDir)
vraWorkitem = "/usr/share/gugent/site/workitem.xml"

if os.path.isfile(vraWorkitem):
	wrkItemTree = ET.parse('/usr/share/gugent/site/workitem.xml')
	root = wrkItemTree.getroot()
	vraJson = {}

	for prop in root[0].findall('property'):
		vraPropName = prop.get('name').replace('.','_')
		vraPropValue = prop.get('value')
		vraJson[vraPropName] =  vraPropValue

	with open(vraFacts, 'w') as outfile:
		json.dump(vraJson, outfile)
