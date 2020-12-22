install:
	pip install nbconvert

CPI:
	@echo "reading the file about CPI"
	ipython nbconvert --to=python revise_CPI.ipynb
	@echo "running the file that revises CPI"
	python revise_CPI.py runserver


codes:
	@echo "reading the file that organzieses codes"
	ipython nbconvert --to=python codes.ipynb
	@echo "running the file about organizes codes"
	python codes.py runserver

CPS:
	@echo "reading the file of CPS version 2"
	ipython nbconvert --to=python CPS_version2.ipynb
	@echo "running the file of CPS version 2"
	python CPS_version2.py runserver
