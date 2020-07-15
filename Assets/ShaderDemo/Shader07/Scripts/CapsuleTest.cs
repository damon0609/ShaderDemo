using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CapsuleTest : MonoBehaviour
{
    private Material material;

    public Transform plane;

    private int upDir;
    private int point;

    private Vector3 mPoint;
    private Vector3 planeNormal;

    private Vector3[] vertexList;

    private Vector3 p1, p2, p3;
    private Matrix4x4 localToWorldMatrix;

    private Vector3[] targetList;

    public float speed = 5;

    public bool showGizmos = false;
    void Start()
    {
        UpdatePos();
        upDir = Shader.PropertyToID("_PlaneNormal");
        point = Shader.PropertyToID("_Point");
        material = transform.GetComponent<MeshRenderer>().material;
    }

    private void OnDrawGizmos()
    {
        if(!showGizmos) return;
        UpdatePos();
        Gizmos.color = Color.black;
        Gizmos.DrawLine(mPoint, mPoint + planeNormal.normalized);
        Gizmos.DrawLine(p1, p1 + planeNormal.normalized);
        Gizmos.DrawLine(p2, p2 + planeNormal.normalized);
        Gizmos.DrawLine(p3, p3 + planeNormal.normalized);


        Gizmos.color = Color.red;
        for (int i = 0; i < targetList.Length; i++)
        {
            Gizmos.DrawLine(p1, targetList[i]);
            Gizmos.DrawSphere(targetList[i], 0.01f);
        }
    }

    void UpdatePos()
    {
        if (plane != null)
        {
            localToWorldMatrix = plane.localToWorldMatrix;


            vertexList = plane.GetComponent<MeshFilter>().sharedMesh.vertices;
            mPoint = plane.position;
            planeNormal = localToWorldMatrix.MultiplyVector(Vector3.up).normalized;
            p1 = localToWorldMatrix.MultiplyPoint(vertexList[0]);
            p2 = localToWorldMatrix.MultiplyPoint(vertexList[1]);
            p3 = localToWorldMatrix.MultiplyPoint(vertexList[vertexList.Length - 1]);
        }
        if (targetList == null)
        {
            targetList = transform.GetComponent<MeshFilter>().sharedMesh.vertices;
        }

    }

    void Update()
    {
        UpdatePos();
        // plane.Rotate(Vector3.right, Time.deltaTime * speed);
        material.SetVector(point, p1);
        material.SetVector(upDir, planeNormal);
    }
}
