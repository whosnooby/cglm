# 🎥 OpenGL Mathematics (glm) for `C`

<p align="center">
   <img alt="" src="cglm.png" width="550" />
</p>

<br>

<p align="center">
Highly optimized 2D|3D math library, also known as <b>OpenGL Mathematics (glm) for `C`</b>. <b>cglm</b> provides lot of utils to help math operations to be fast and quick to write. It is community friendly, feel free to bring any issues, bugs you faced. 
</p>

#### About this fork
The [whosnooby/clgm](https://github.com/whosnooby/cglm) fork is a stripped down version of [recp/cglm](https://github.com/recp/cglm) without any tests or documentation. It uses the [premake build system](https://premake.github.io) instead of CMake.

---

#### 📚 Documentation

Almost all functions (inline versions) and parameters are documented inside the corresponding headers. <br />
Complete documentation: http://cglm.readthedocs.io


#### 📌 Note for new comers (Important):
- `vec4` and `mat4` variables must be aligned. (There will be unaligned versions later)
- **in** and **[in, out]** parameters must be initialized (please). But **[out]** parameters not, initializing out param is  also redundant
- All functions are inline if you don't want to use pre-compiled versions with glmc_ prefix, you can ignore build process. Just include headers.
- if your debugger takes you to cglm headers then make sure you are not trying to copy vec4 to vec3 or alig issues...

<hr/>

<table>
  <tbody>
    <tr>
      <td>
        <div>Like some other graphics libraries (especially OpenGL) this library use Column-Major layout to keep matrices in the memory. </div>
        <div>&nbsp;</div>
        <div>In the future the library may support an option to use row-major layout, CURRENTLY if you need to row-major layout you will need to transpose it. </div>
      </td>
      <td>
        <img src="https://upload.wikimedia.org/wikipedia/commons/3/3f/Matrix_Columns.svg" width="300px" />
      </td>
    </tr>
  </tbody>
</table>

## 🚀 Features
- **scalar** and **simd** (sse, avx, neon...) optimizations
- option to use different clipspaces e.g. Left Handed, Zero-to-One... (currently right handed negative-one is default)
- array api and struct api, you can use arrays or structs.
- general purpose matrix operations (mat4, mat3)
- chain matrix multiplication (square only)
- general purpose vector operations (cross, dot, rotate, proj, angle...)
- affine transformations
- matrix decomposition (extract rotation, scaling factor)
- optimized affine transform matrices (mul, rigid-body inverse)
- camera (lookat)
- projections (ortho, perspective)
- quaternions
- euler angles / yaw-pitch-roll to matrix
- extract euler angles
- inline or pre-compiled function call
- frustum (extract view frustum planes, corners...)
- bounding box (AABB in Frustum (culling), crop, merge...)
- bounding sphere
- project, unproject
- easing functions
- curves
- curve interpolation helpers (S*M*C, deCasteljau...)
- helpers to convert cglm types to Apple's simd library to pass cglm types to Metal GL without packing them on both sides
- ray intersection helpers
- and others...

<hr />

You have two options to call a function/operation: inline or library call (link)
Almost all functions are marked inline (always_inline) so compiler will probably inline.
To call pre-compiled versions, just use `glmc_` (c stands for 'call') instead of `glm_`.

```C
  #include <cglm/cglm.h>   /* for inline */
  #include <cglm/call.h>   /* for library call (this also includes cglm.h) */

  mat4 rot, trans, rt;
  /* ... */
  glm_mul(trans, rot, rt);  /* inline */
  glmc_mul(trans, rot, rt); /* call from library */
```
Most of math functions are optimized manually with SSE2 if available, if not? Dont worry there are non-sse versions of all operations

You can pass matrices and vectors as array to functions rather than get address.

```C
  mat4 m = {
    1, 0, 0, 0,
    0, 1, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1
  };

  glm_translate(m, (vec3){1.0f, 0.0f, 0.0f});
```

Library contains general purpose mat4 mul and inverse functions, and also contains some special forms (optimized) of these functions for affine transformations' matrices. If you want to multiply two affine transformation matrices you can use glm_mul instead of glm_mat4_mul and glm_inv_tr (ROT + TR) instead glm_mat4_inv
```C
/* multiplication */
mat4 modelMat;
glm_mul(T, R, modelMat);

/* othonormal rot + tr matrix inverse (rigid-body) */
glm_inv_tr(modelMat);
```

### Struct API

The struct API works as follows, note the `s` suffix on types, the `glms_` prefix on functions and the `GLMS_` prefix on constants:

```C
#include <cglm/struct.h>

mat4s mat = GLMS_MAT4_IDENTITY_INIT;
mat4s inv = glms_mat4_inv(mat);
```

Struct functions generally take their parameters as *values* and *return* their results, rather than taking pointers and writing to out parameters. That means your parameters can usually be `const`, if you're into that.

The types used are actually unions that allow access to the same data multiple ways. One of those ways involves anonymous structures, available since C11. MSVC also supports it for earlier C versions out of the box and GCC/Clang do if you enable `-fms-extensions`. To explicitly enable these anonymous structures, `#define CGLM_USE_ANONYMOUS_STRUCT` to `1`, to disable them, to `0`. For backward compatibility, you can also `#define CGLM_NO_ANONYMOUS_STRUCT` (value is irrelevant) to disable them. If you don't specify explicitly, cglm will do a best guess based on your compiler and the C version you're using.

## How to use
If you want to use the inline versions of functions, then include the main header
```C
#include <cglm/cglm.h>
```
the header will include all headers. Then call the func you want e.g. rotate vector by axis:
```C
glm_vec3_rotate(v1, glm_rad(45), (vec3){1.0f, 0.0f, 0.0f});
```
some functions are overloaded :) e.g you can normalize vector:
```C
glm_vec3_normalize(vec);
```
this will normalize vec and store normalized vector into `vec` but if you will store normalized vector into another vector do this:
```C
glm_vec3_normalize_to(vec, result);
```
like this function you may see `_to` postfix, this functions store results to another variables and save temp memory


to call pre-compiled versions include header with `c` postfix, c means call. Pre-compiled versions are just wrappers.
```C
#include <cglm/call.h>
```
this header will include all headers with c postfix. You need to call functions with c posfix:
```C
glmc_vec3_normalize(vec);
```

Function usage and parameters are documented inside related headers. You may see same parameter passed twice in some examples like this:
```C
glm_mat4_mul(m1, m2, m1);

/* or */
glm_mat4_mul(m1, m1, m1);
```
the first two parameter are **[in]** and the last one is **[out]** parameter. After multiplying *m1* and *m2*, the result is stored in *m1*. This is why we send *m1* twice. You may store the result in a different matrix, this is just an example.

### Example: Computing MVP matrix

#### Option 1
```C
mat4 proj, view, model, mvp;

/* init proj, view and model ... */

glm_mat4_mul(proj, view, viewProj);
glm_mat4_mul(viewProj, model, mvp);
```

#### Option 2
```C
mat4 proj, view, model, mvp;

/* init proj, view and model ... */

glm_mat4_mulN((mat4 *[]){&proj, &view, &model}, 3, mvp);
```

## How to send matrix to OpenGL

mat4 is array of vec4 and vec4 is array of floats. `glUniformMatrix4fv` functions accecpts `float*` as `value` (last param), so you can cast mat4 to float* or you can pass first column of matrix as beginning of memory of matrix:

Option 1: Send first column
```C
glUniformMatrix4fv(location, 1, GL_FALSE, matrix[0]);

/* array of matrices */
glUniformMatrix4fv(location, 1, GL_FALSE, matrix[0][0]);
```

Option 2: Cast matrix to pointer type (also valid for multiple dimensional arrays)
```C
glUniformMatrix4fv(location, 1, GL_FALSE, (float *)matrix);
```

You can pass matrices the same way to other APIs e.g. Vulkan, DX...


## Contributors

This project exists thanks to all the people who contribute. [[Contribute](CONTRIBUTING.md)].
<a href="https://github.com/recp/cglm/graphs/contributors"><img src="https://opencollective.com/cglm/contributors.svg?width=890&button=false" /></a>

## License
MIT. check the LICENSE file
