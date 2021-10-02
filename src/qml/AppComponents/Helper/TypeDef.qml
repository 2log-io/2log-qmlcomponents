/*   2log.io
 *   Copyright (C) 2021 - 2log.io | mail@2log.io,  mail@friedemann-metzger.de
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU Affero General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU Affero General Public License for more details.
 *
 *   You should have received a copy of the GNU Affero General Public License
 *   along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */


import QtQuick 2.5
//import UIControls 1.0

pragma Singleton

Item
{

    function parseISOLocal(s) {
      var b = s.split(/\D/);
      return new Date(b[0], b[1]-1, b[2], b[3], b[4], b[5]);
    }


    property var machineType:
    [
        {
            "name":qsTr("Tellerschleifer"),
            "code":"tellerschl",
            "icon":"tellerschleiferIcon"
        },
        {
            "name":qsTr("Bandschleifer"),
            "code":"bandschl",
            "icon":"bandschleiferIcon"
        },
        {
            "name":qsTr("Tischkreissäge"),
            "code":"teller",
            "icon":"tischkreissaegeIcon"
        },
        {
            "name":qsTr("Lasercutter"),
            "code":"lasercutter",
            "icon":"lasercutterIcon"
        },
        {
            "name":qsTr("Bandsäge"),
            "code":"bandsaege",
            "icon":"bandsaegeIcon"
        },
        {
            "name":qsTr("Folienplotter"),
            "code":"plotter",
            "icon":"plotterIcon"
        },
        {
            "name":qsTr("Heißdraht"),
            "code":"heissdraht",
            "icon":"heiszdraht"
        },

        {
            "name":qsTr("Standbohrmaschine"),
            "code":"standbohr",
            "icon":"standbohrerIcon"
        },
        {
            "name":qsTr("Plattenfräse"),
            "code":"plattenfraese",
            "code":"plattenfraeseIcon"
        }
    ]





    property var roles:
    [
        {
            "name":qsTr("Student"),
            "code":"stud"
        },
        {
            "name":qsTr("Angestellter"),
            "code":"empl",
        },
        {
            "name":qsTr("Extern"),
            "code":"ext",
        }
    ]


    property var adminRoles:
    [
        {
            "name":qsTr("Mitarbeiter"),
            "code":"empl",
        },
        {
            "name":qsTr("Sekretariat"),
            "code":"mngmt",
        },
        {
            "name":qsTr("Admin"),
            "code":"admin",
        },
        {
            "name":qsTr("Kassierer*in"),
            "code":"cash",
        }
    ]

    function getLongStrings(map)
    {
        return map.map((function (x) {
            return x.name
          }))
    }

    function getIndexOf(map, code)
    {
        var i = 0
        var result = -1
        map.find(function(element)
        {
          if(element.code === code)
          {
              result = i
          }
          i = i+1;
        })
        return result
    }

    function getMachineIconSource(machine)
    {
        if(machine === null || machine === "" || machine === undefined)
            return ""
        var index = getIndexOf(machineType, machine)
        var value = machineType[index]
        return value.icon
    }

    property var courses:
    [
        {
            "name":qsTr("Produktdesign"),
            "code":"pd"
        },
        {
            "name":qsTr("Kommunikationsdesign"),
            "code":"kd",
        },
        {
            "name":qsTr("Kunsterziehung"),
            "code":"ke",
        },
        {
            "name":qsTr("Freie Kunst"),
            "code":"fk",
        },
        {
            "name":qsTr("Media Art And Design"),
            "code":"mad",
        },
        {
            "name":qsTr("Architektur"),
            "code":"arch",
        },
        {
            "name":qsTr("Promotion"),
            "code":"pro",
        },
        {
            "name":qsTr("Kuratieren"),
            "code":"kur",
        },
        {
            "name":qsTr("Museumspädagogik"),
            "code":"mpaed",
        },
        {
            "name":qsTr("Netzkultur"),
            "code":"nk",
        }
    ]

    function getIcon(tag)
    {
        if (tag === "plotter")
            return ""

        if (tag === "3dprinter")
            return ""

        if (tag === "laser")
            return ""

        if (tag === "handTool")
            return ""

        if (tag === "box")
            return ""

        return ""
    }

    function getImage(tag)
    {
        if (tag === "plotter")
            return "qrc:/QuickLabControls/Assets/Pics/Schneidplotter_white.svg"

        if (tag === "3dprinter")
            return ":/QuickLabControls/Assets/Pics/Ultimaker_white.svg"

        if (tag === "laser")
            return "QuickLabControls/Assets/Pics/Laser_white.svg"

        if (tag === "handTool")
             return "QuickLabControls/Assets/Pics/Flex_white.svg"

        return ""
    }
}
