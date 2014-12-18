mt-plugin-each-slice
====================

Movable Type plugin splits loop to sub-loops.

# Examples

## Example array

    $array = [
        { value => 'A' },
        { value => 'B' },
        { value => 'C' },
        { value => 'D' },
        { value => 'E' },
        { value => 'F' },
        { value => 'G' },
    ];


## Example 1: splits loop by 2

### Template

    <mt:EachSlice by="2">
    <mt:Loop name="array">
    <mt:EachSliceHeader><ul></mt:EachSliceHeader>
    <mt:EachSliceBody><li><mt:Var name="value"></li></mt:EachSliceBody>
    <mt:EachSliceFooter></ul></mt:EachSliceFooter>
    </mt:Loop>
    </mt:EachSlice>

### Result

    <ul>
    <li>A</li>
    <li>B</li>
    </ul>
    <ul>
    <li>C</li>
    <li>D</li>
    </ul>
    <ul>
    <li>E</li>
    <li>F</li>
    </ul>
    <ul>
    <li>G</li>
    </ul>

## Example 2: splits loop to 2

### Template

    <mt:EachSlice to="2">
    <mt:Loop name="array">
    <mt:EachSliceHeader><ul></mt:EachSliceHeader>
    <mt:EachSliceBody><li><mt:Var name="value"></li></mt:EachSliceBody>
    <mt:EachSliceFooter></ul></mt:EachSliceFooter>
    </mt:Loop>
    </mt:EachSlice>

### Result

    <ul>
    <li>A</li>
    <li>B</li>
    <li>C</li>
    <li>D</li>
    </ul>
    <ul>
    <li>E</li>
    <li>F</li>
    <li>G</li>
    </ul>

