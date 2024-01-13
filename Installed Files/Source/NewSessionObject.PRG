Lparameters lcClassName, lcClassLib, lxParam1, lxParam2, lxParam3

* Creates a session object -- which then creates (and contains) the actual business object
* This business object is returned, and has the data session associated with the original session object (its parent)

* The session object is discarded, and the custom object is returned -- with its own data session

Local loObject
loObject = CreateObject ('LocalSessionClass',		;
	  lcClassName, lcClassLib, Pcount() - 2, lxParam1, lxParam2, lxParam3)
Return loObject.GetCustom()



Define Class LocalSessionClass As Session

	oCustom = .Null.

	Procedure Init  (lcClassName, lcModule, lnParams, lxParam1, lxParam2, lxParam3)
		Do Case
			Case lnParams = 0
				This.oCustom = Newobject(lcClassName, lcModule)
			Case lnParams = 1
				This.oCustom = Newobject(lcClassName, lcModule, '', lxParam1)
			Case lnParams = 2
				This.oCustom = Newobject(lcClassName, lcModule, '', lxParam1, lxParam2)
			Case lnParams = 3
				This.oCustom = Newobject(lcClassName, lcModule, '', lxParam1, lxParam2, lxParam3)
		Endcase
	Endproc

	Procedure GetCustom
		Return This.oCustom
	Endproc

Enddefine
