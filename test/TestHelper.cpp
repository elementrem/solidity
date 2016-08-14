/*
	This file is part of cpp-elementrem.

	cpp-elementrem is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	cpp-elementrem is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with cpp-elementrem.  If not, see <http://www.gnu.org/licenses/>.
*/
/** @file TestHelper.h
* 
* 
*/

#include <boost/test/framework.hpp>
#include "TestHelper.h"
using namespace std;
using namespace dev::test;

Options::Options(int argc, char** argv)
{
	tArgc = 0;
	tArgv = new char*[argc];
	for (auto i = 0; i < argc; i++)
	{
		string arg = argv[i];
		if (arg == "--ipc" && i + 1 < argc)
		{
			ipcPath = argv[i + 1];
			i++;
		}
		else
		{
			tArgv[i] = argv[i];
			tArgc++;
		}
	}
}

Options const& Options::get(int argc, char** argv)
{
	static Options instance(argc, argv);
	return instance;
}