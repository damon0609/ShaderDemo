using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NormalDemo : MonoBehaviour {
    private Transform cache;
    private MeshFilter meshFilter;
    private Mesh mesh;

    private Matrix4x4 localToworldMatrix;
    private Matrix4x4 localToWorldInverseTranspose;

    public bool worldNormal = true;
    private void OnDrawGizmos () {
        if (cache == null) {
            cache = transform;
            meshFilter = cache.GetComponent<MeshFilter> ();
            mesh = meshFilter.mesh;
        }
        localToworldMatrix = cache.transform.localToWorldMatrix; //本地到世界的矩阵
        localToWorldInverseTranspose = localToworldMatrix.inverse.transpose; //逆矩阵-》转置矩阵

        Vector3[] normals = mesh.normals;
        Vector3[] points = mesh.vertices;
        Vector3[] tangents = new Vector3[mesh.tangents.Length];
        Vector3[] btangents = new Vector3[mesh.tangents.Length];

        for (int i = 0; i < mesh.tangents.Length; i++) {

            Vector4 t = mesh.tangents[i];
            float x = t.x;
            float y = t.y;
            float z = t.z;
            float w = t.w;

            Vector3 temp = new Vector3 (x, y, z); //切线
            tangents[i] = temp;

            Vector3 b = Vector3.Cross (normals[i], temp) * w; //副切线
            btangents[i] = b;
        }

        if (worldNormal) {
            DrawLine (points, normals, ref localToworldMatrix, ref localToWorldInverseTranspose, 0.1f, Color.blue);
            DrawLine (points, tangents, ref localToworldMatrix, ref localToWorldInverseTranspose, 0.1f, Color.red);
            DrawLine (points, btangents, ref localToworldMatrix, ref localToWorldInverseTranspose, 0.1f, Color.green);
        } else {
            Vector3[] worldSpacePoint = new Vector3[points.Length];
            Vector3[] worldTangents = new Vector3[points.Length];
            Vector3[] worldBTangent = new Vector3[points.Length];
            Vector3[] worldNormal = new Vector3[points.Length];
            Matrix4x4[] matrices = TangentSpace (tangents, normals, btangents);
            for (int i = 0; i < points.Length; i++) {
                //将本地坐标转成世界坐标
                worldSpacePoint[i] = localToworldMatrix.MultiplyPoint (points[i]);
                worldTangents[i] = localToworldMatrix.MultiplyVector (tangents[i]);
                worldBTangent[i] = localToworldMatrix.MultiplyVector (btangents[i]);
                worldNormal[i] = localToworldMatrix.MultiplyVector (normals[i]);
            }

            DrawLine (worldSpacePoint, worldTangents, matrices, 0.1f, Color.red);
            DrawLine (worldSpacePoint, worldBTangent, matrices, 0.1f, Color.green);
            DrawLine (worldSpacePoint, worldNormal, matrices, 0.1f, Color.blue);

            // Gizmos.color = Color.blue;
            // //将顶点，切线，副切线，法线转成切线空间下法线
            // for (int i = 0; i < matrices.Length; i++) {
            //     Vector3 dir = matrices[i].MultiplyVector (worldBTangent[i])*mesh.tangents[i].w;
            //     Vector3 start = worldSpacePoint[i];
            //     Vector3 end = start + dir.normalized * 0.1f;
            //     Gizmos.DrawLine (start, end);
            // }
            // Gizmos.color = Color.white;
        }
    }

    //世界空间下的法线,切线空间
    void DrawLine (Vector3[] vextor3s, Vector3[] vector3s, ref Matrix4x4 vextor3, ref Matrix4x4 vector3, float length, Color color) {

        Gizmos.color = color;
        for (int i = 0; i < vector3s.Length; i++) {
            Vector3 point = Vector3.zero;
            Vector3 dir = Vector3.zero;
            point = vextor3.MultiplyPoint (vextor3s[i]); //矩阵转换点
            dir = vector3.MultiplyVector (vector3s[i]); //矩阵转换向量
            Gizmos.DrawLine (point, point + dir.normalized * length);
        }
        Gizmos.color = Color.white;
    }

    void DrawLine (Vector3[] vexters, Vector3[] dirs, Matrix4x4[] matrixList, float length, Color color) {

        Vector3[] tangentPoint = new Vector3[matrixList.Length];
        Vector3[] dirTangents = new Vector3[matrixList.Length];

        Gizmos.color = color;
        //将顶点，切线，副切线，法线转成切线空间下法线
        for (int i = 0; i < matrixList.Length; i++) {
            tangentPoint[i] = vexters[i];
            dirTangents[i] = matrixList[i].MultiplyVector (dirs[i]);
            Vector3 start = tangentPoint[i];
            Vector3 end = start + dirTangents[i].normalized * length;
            Gizmos.DrawLine (start, end);
        }
        Gizmos.color = Color.white;
    }
    //获取切线空间的矩阵
    Matrix4x4[] TangentSpace (Vector3[] tanget, Vector3[] normals, Vector3[] btangent) {
        Matrix4x4[] matrixList = new Matrix4x4[tanget.Length];
        for (int i = 0; i < tanget.Length; i++) {
            Vector3 tan = tanget[i];
            Vector3 btan = btangent[i];
            Vector3 normal = normals[i];
            Vector4 xAxis = new Vector4 (tan.x, btan.x, normal.x, 0);
            Vector4 yAxis = new Vector4 (tan.y, btan.y, normal.y, 0);
            Vector4 zAixs = new Vector4 (tan.z, btan.z, normal.z, 0);
            Vector4 wAxis = new Vector4 (0, 0, 0, 1);
            Matrix4x4 tangentSpace = new Matrix4x4 (
                xAxis,
                yAxis,
                zAixs,
                wAxis
            );
            matrixList[i] = tangentSpace;
        }
        return matrixList;
    }

    void Start () {

    }
    void Update () {

    }
}