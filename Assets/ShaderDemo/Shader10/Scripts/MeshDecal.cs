using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
public class MeshDecal : MonoBehaviour {
    private MeshRenderer render;

    private List<int> indexList = new List<int> ();
    private List<Vector3> vertexList = new List<Vector3> ();
    private List<Vector3> normalList = new List<Vector3> ();
    private List<Vector2> uvList = new List<Vector2> ();
    void Start () { }

    [ContextMenu ("Mesh Decal")]
    void Generate () {
        render = transform.GetComponent<MeshRenderer> ();
        MeshRenderer[] renders = FindObjectsOfType<MeshRenderer> ();
        foreach (MeshRenderer r in renders) {
            if (r.GetComponent<MeshDecal> () != null)
                continue;
            if (render.bounds.Intersects (r.bounds)) {
                GenerateData (r);
            }
        }
    }

    void GenerateData (MeshRenderer r) {

        var targetMatrix = transform.worldToLocalMatrix * r.transform.localToWorldMatrix;

        Mesh targetMesh = r.gameObject.GetComponent<MeshFilter> ().sharedMesh;
        int[] triangles = targetMesh.triangles;
        Vector3[] vertexes = targetMesh.vertices;

        //拼装成三角形
        for (int i = 0; i < triangles.Length; i += 3) {

            //使用三角形索引号取顶点坐标可以保证组成的正确的显示三角形
            int index0 = triangles[i];
            int index1 = triangles[i + 1];
            int index2 = triangles[i + 2];

            Vector3 v0 = vertexes[index0];
            Vector3 v1 = vertexes[index1];
            Vector3 v2 = vertexes[index2];

            v0 = targetMatrix.MultiplyPoint (v0);
            v1 = targetMatrix.MultiplyPoint (v1);
            v2 = targetMatrix.MultiplyPoint (v2);

            var list = new List<Vector3> ();
            list.Add (v0);
            list.Add (v1);
            list.Add (v2);

            //每组三角形都进行检查
            if (CollisionChecker.Checker (list)) {
                Vector3 first = v0 - v1;
                Vector3 second = v0 - v2;
                Vector3 normal = Vector3.Cross (first, second).normalized;
                AddPolygon (list.ToArray (), normal);
                GenerateMesh ();
            }
        }
    }
    void GenerateMesh () {
        Mesh mesh = new Mesh ();
        mesh.name = "MeshDecal";
        mesh.vertices = vertexList.ToArray();
        mesh.triangles = indexList.ToArray();
        mesh.uv = uvList.ToArray();
        mesh.normals = normalList.ToArray();

        transform.GetComponent<MeshFilter>().mesh = mesh;
    }

    void AddPolygon (Vector3[] list, Vector3 normal) {
        int index0 = AddVertext (list[0], normal);
        for (int i = 1; i < list.Length - 1; i++) {
            int index1 = AddVertext (list[i], normal);
            int index2 = AddVertext (list[i + 1], normal);

            indexList.Add (index0);
            indexList.Add (index1);
            indexList.Add (index2);
        }
    }
    int AddVertext (Vector3 p, Vector3 normal) {
        int index = FindVertext (p);
        if (index == -1) {
            vertexList.Add (p);
            normalList.Add (normal);
            float u = Mathf.Lerp (0.0f, 1.0f, p.x + 0.5f); //这个用的巧妙
            float v = Mathf.Lerp (0.0f, 1.0f, p.y + 0.5f);
            uvList.Add (new Vector2 (u, v));
            return vertexList.Count - 1; //这里需要注意
        } else {
            normalList[index] = (normalList[index] + normal).normalized;
            return index;
        }
    }

    //判断是否有顶点相同的
    int FindVertext (Vector3 p) {
        for (int i = 0; i < vertexList.Count; i++) {
            if (Vector3.Distance (vertexList[i], p) < 0.01f) return i;
        }
        return -1;
    }
    public static class CollisionChecker {
        private static bool Checker (Plane plane, List<Vector3> list) {
            int outSideCount = 0;
            for (int i = 0; i < list.Count; i++) {
                if (plane.GetSide (list[i])) {
                    outSideCount++;
                }
            }
            if (outSideCount == list.Count)
                return false;
            return true;
        }

        public static bool Checker (List<Vector3> list) {
            bool result = Checker (frontPlane, list);
            result |= Checker (backPlane, list);
            result |= Checker (leftPlane, list);
            result |= Checker (rightPlane, list);
            result |= Checker (topPlane, list);
            result |= Checker (bottomPlane, list);
            return !result;
        }

        private const float d = 0.5f;
        private static Plane frontPlane;
        private static Plane backPlane;
        private static Plane leftPlane;
        private static Plane rightPlane;
        private static Plane topPlane;
        private static Plane bottomPlane;
        static CollisionChecker () {
            frontPlane = new Plane (Vector3.forward, d);
            backPlane = new Plane (Vector3.back, d);
            leftPlane = new Plane (Vector3.left, d);
            rightPlane = new Plane (Vector3.right, d);
            topPlane = new Plane (Vector3.up, d);
            bottomPlane = new Plane (Vector3.down, d);
        }
    }
}