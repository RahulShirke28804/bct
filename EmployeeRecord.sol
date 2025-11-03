// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title EmployeeRecord - Store and retrieve employee details using structs, arrays, and fallback
contract EmployeeRecord {
    // Structure for Employee
    struct Employee {
        uint empId;
        string name;
        string department;
        uint salary;
    }

    // Dynamic array to store all employees
    Employee[] public employees;

    // Event to log employee addition
    event EmployeeAdded(uint empId, string name, string department, uint salary);

    /// @notice Add a new employee record
    /// @param _empId Unique Employee ID
    /// @param _name Employee name
    /// @param _department Department name
    /// @param _salary Employee salary in wei (or abstract units)
    function addEmployee(
        uint _empId,
        string memory _name,
        string memory _department,
        uint _salary
    ) public {
        employees.push(Employee(_empId, _name, _department, _salary));
        emit EmployeeAdded(_empId, _name, _department, _salary);
    }

    /// @notice Get details of an employee by array index
    /// @param index Position in the employee array
    /// @return empId, name, department, salary
    function getEmployee(uint index)
        public
        view
        returns (uint, string memory, string memory, uint)
    {
        require(index < employees.length, "Invalid index");
        Employee memory emp = employees[index];
        return (emp.empId, emp.name, emp.department, emp.salary);
    }

    /// @notice Get the total number of employees
    function getEmployeeCount() public view returns (uint) {
        return employees.length;
    }

    /// @notice Fallback function — called for invalid transactions or unknown function calls
    fallback() external payable {
        revert("Invalid call: Fallback function triggered");
    }

    /// @notice Receive function — to accept Ether if sent directly
    receive() external payable {
        // Accept Ether silently (optional)
    }
}
