using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(MeshFilter), typeof(MeshRenderer))]
public class Mesh03 : MonoBehaviour
{
    public Vector3 p1;
    public Vector3 p2;
    public Vector3 p3;

    private Matrix4x4 matrix;
    private Vector3 p11;
    private Vector3 p22;
    private Vector3 p33;

    private void OnDrawGizmos()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawSphere(p11, 0.1f);
        Gizmos.DrawSphere(p22, 0.1f);
        Gizmos.DrawSphere(p33, 0.1f);
    }

    private MeshRenderer meshRenderer;
    private MeshFilter meshFilter;
    private Mesh tempMesh;

    private void Start()
    {
      
    }
    [ContextMenu("GenerateMesh")]
    void GenerateMesh()
    {
        meshFilter = transform.GetComponent<MeshFilter>();
        meshRenderer = transform.GetComponent<MeshRenderer>();

        matrix = transform.localToWorldMatrix;
        p11 = matrix.MultiplyPoint(p1);
        p22 = matrix.MultiplyPoint(p2);
        p33 = matrix.MultiplyPoint(p3);

        tempMesh = new Mesh();
        tempMesh.name = "tempMesh";
        tempMesh.vertices = new Vector3[3] { p11, p22, p33 };
        tempMesh.triangles = new int[3] { 0, 1, 2 };
        tempMesh.RecalculateNormals();
        tempMesh.RecalculateBounds();
        tempMesh.RecalculateTangents();

        meshFilter.mesh = tempMesh;
    }
   
}
