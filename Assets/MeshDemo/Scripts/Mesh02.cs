using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent (typeof (MeshFilter), typeof (MeshRenderer))]
public class Mesh02 : MonoBehaviour {

    private MeshFilter meshFilter;
    private MeshRenderer render;
    private Mesh mesh;
    public int xSize, ySize, zSize;

    private Vector3[] vertexList;
    private int[] triangles;
    void Start () {
        if (meshFilter == null)
            meshFilter = transform.GetComponent<MeshFilter> ();

        if (render == null)
            render = transform.GetComponent<MeshRenderer> ();

        int vertexCount = 8;
        int facePointCount = (xSize + 1 - 2) * (zSize + 1 - 2) * 2 +
            (xSize + 1 - 2) * (ySize + 1 - 2) * 2 +
            (ySize + 1 - 2) * (zSize + 1 - 2) * 2;
        int edgePointCount = (xSize + 1 - 2) * 4 + (ySize + 1 - 2) * 4 + (zSize + 1 - 2) * 4;
        vertexCount += facePointCount + edgePointCount;

        vertexList = new Vector3[vertexCount];
        StartCoroutine (GenerateMesh ());
    }

    IEnumerator GenerateMesh () {
        WaitForSeconds wait = new WaitForSeconds (0.0f);
        int index = 0;
        for (int y = 0; y <= ySize; y++) {
            for (int x = 0; x <= xSize; x++) {
                vertexList[index++] = new Vector3 (x, y, 0);
                yield return wait;
            }
            for (int z = 1; z <= zSize; z++) {
                vertexList[index++] = new Vector3 (xSize, y, z);
                yield return wait;
            }
            for (int x = xSize - 1; x >= 0; x--) {
                vertexList[index++] = new Vector3 (x, y, zSize);
                yield return wait;
            }
            for (int z = zSize - 1; z > 0; z--) {
                vertexList[index++] = new Vector3 (0, y, z);
                yield return wait;
            }
        }
        for (int x = 1; x < zSize; x++) {
            for (int z = 1; z < xSize; z++) {
                vertexList[index++] = new Vector3 (x, ySize, z);
                yield return wait;
            }
        }
        for (int x = 1; x < zSize; x++) {
            for (int z = 1; z < xSize; z++) {
                vertexList[index++] = new Vector3 (x, 0, z);
                yield return wait;
            }
        }
        mesh = new Mesh ();
        mesh.name = "Procedure Cube";
        mesh.vertices = vertexList;

        GenerateTriangle ();
        mesh.triangles = triangles;

        meshFilter.mesh = mesh;
    }

    private void GenerateTriangle () {
        int trianglesCount = (xSize * ySize) * 4 + (zSize * ySize) * 4 + (xSize + zSize) * 4;
        triangles = new int[trianglesCount];
        int ring = (xSize + zSize) * 2;
        int v = 0, t = 0;
        for (int i = 0; i < ring - 1; i++, v++) {
            t = SetQuad (triangles, t, v, v + 1, v + ring, v + ring + 1);
        }

        //这里绘制的就是一个四边形
        t = SetQuad (triangles, t, v, v - ring + 1, v + ring, v + 1);
    }

    //这个函数设计的巧妙
    private static int SetQuad (int[] triangles, int i, int v00, int v10, int v01, int v11) {
        triangles[i] = v00;
        triangles[i + 1] = triangles[i + 4] = v01;
        triangles[i + 2] = triangles[i + 3] = v10;
        triangles[i + 5] = v11;
        return i += 6;
    }
    private void OnDrawGizmos () {

        if (!Application.isPlaying) return;

        Gizmos.color = Color.black;
        for (int i = 0; i < vertexList.Length; i++) {
            Gizmos.DrawSphere (vertexList[i], 0.1f);
        }
        Gizmos.color = Color.white;
    }
}